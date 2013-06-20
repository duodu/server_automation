class InstancesController < ApplicationController
  # GET /instances
  # GET /instances.json
  def index
    @instances = Instance.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @instances }
    end
  end

  # GET /instances/1
  # GET /instances/1.json
  def show
    @instance = Instance.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @instance }
    end
  end

  # GET /instances/new
  # GET /instances/new.json
  def new
    @instance = Instance.new
    @ip_array = Ip.all.map { |ip| [ip.name, ip.id] }
    @port_array = Port.all.map { |port| [port.name, port.id] }
    @account_array = Account.all.map { |user| [user.username, user.id] }

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @instance }
    end
  end

  # GET /instances/1/edit
  def edit
    @instance = Instance.find(params[:id])
    @ip_array = Ip.all.map { |ip| [ip.name, ip.id] }
    @port_array = Port.all.map { |port| [port.name, port.id] }
    @account_array = Account.all.map { |user| [user.username, user.id] }
  end

  # POST /instances
  # POST /instances.json
  def create
    @instance = Instance.new(params[:instance])

    respond_to do |format|
      if @instance.save
        format.html { redirect_to @instance, notice: 'Instance was successfully created.' }
        format.json { render json: @instance, status: :created, location: @instance }
      else
        format.html { render action: "new" }
        format.json { render json: @instance.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /instances/1
  # PUT /instances/1.json
  def update
    @instance = Instance.find(params[:id])
    @ip_array = Ip.all.map { |ip| [ip.name, ip.id] }
    @port_array = Port.all.map { |port| [port.name, port.id] }
    @account_array = Account.all.map { |user| [user.username, user.id] }

    respond_to do |format|
      if @instance.update_attributes(params[:instance])
        format.html { redirect_to @instance, notice: 'Instance was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @instance.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /instances/1
  # DELETE /instances/1.json
  def destroy
    @instance = Instance.find(params[:id])
    @instance.destroy

    respond_to do |format|
      format.html { redirect_to instances_url }
      format.json { head :no_content }
    end
  end
  def command
    @instance = Instance.find(params[:id])
    @cmd_array = Command.all.map { |cmd| [cmd.name, cmd.id] }
  end
  def deploy
    Dir::chdir('E:/lib/')
    @instance = Instance.find(params[:id])
    if !Package.where("ip = ? and username = ?",@instance.ip.name,@instance.account.username).empty?
      packages = Package.where("ip = ? and username = ?",@instance.ip.name,@instance.account.username)
      packages.each do |package|
        package_array = package.package_array.split(";")
        path = package.path.name
        package_array.each do |p|
          if File::exists?(p)
            puts p +' exists'
            Net::SCP.start(@instance.ip.name, @instance.account.username, :password => @instance.account.password, :port => @instance.port.name) do |scp|
              scp.upload! p, path do |ch, name, sent, total|
                print "\r#{name}: #{(sent.to_f * 100 / total.to_f).to_i}%"
              end
              print "\n"
              puts p + ' to ' + path + ' upload successfully'
            end
          else
            puts p + ' does not exist'
          end
        end
      end
    else
      flash[:notice] = ["no packages"]
      redirect_to :action => 'error'
    end
    
  end
  def command_send
    @instance = Instance.find(params[:id])
    @cmd = Command.find(params[:cmd_id])
  end
  def read_deploy
    date = Time.new.strftime("%Y%m%d%H%M%S")
    @instance_array = Array.new
    
    excel = Roo::Excelx.new("E:/lib/deploy.xlsx")
    excel.default_sheet = excel.sheets.first
    end_row_line = excel.last_row
    
    flash[:notice] = Array.new
    common_row = Array.new

    i = 0
    line = 1
    while i < 6 && line <= end_row_line
      if excel.cell('A',line) == 'common'
        common_row[i] = line
        i += 1
      end
      line += 1
    end
    common_row.each do |row|
      instance_hash = Hash.new
      for col in excel.first_column..excel.last_column
        package = Package.new
        package.batch_date = date
        package.ip = excel.cell('A',row-1).split("/")[0]
        package.username = excel.cell('A',row-1).split("/")[1]
        # if Ip.find_by_name(ip) != nil && Account.find_by_username(username) != nil
          # ip_id = Ip.find_by_name(ip).id
          # account_id = Account.find_by_username(username).id
          # if !Instance.where("ip_id = ? and account_id = ?",ip_id,account_id).empty?
            # instance_id = Instance.where("ip_id = ? and account_id = ?",ip_id,account_id).last.id
            # package.instance_id = instance_id
          # else
            # flash[:notice] << "You need to add the instance with ip = #{ip} and username = #{username}"
            # package.instance_id = 0
          # end
        # else
          # flash[:notice] << "You need to add ip = #{ip} or username = #{username} first"
          # package.instance_id = 0
        # end
        package.sort = excel.cell(row,col)
        package.package_array = Array.new
        line = row
        while excel.cell(line,col) != nil
          if  excel.cell(line,col) =~ /ar\z/
            package.package_array << excel.cell(line,col)
          end
          line += 1
        end
        package.package_array = package.package_array.join(";")
        instance_hash.store(package.sort,package.package_array)
        if package.save
          
        else
          flash[:notice] = package.errors.full_messages
        end
      end
      instance_hash.store("ip",package.ip)
      instance_hash.store("username",package.username)
      @instance_array << instance_hash
      
    end
    
  end
  def test_ssh
    instance = Instance.find(params[:id])
    begin
      Timeout.timeout(2) do 
        Net::SSH.start(instance.ip.name, instance.account.username, :password => instance.account.password, :port => instance.port.name) do |ssh|
          @ret = ssh.exec! 'pwd'
        end
      end
    rescue Exception
      if @ret == nil
        flash[:notice] = ["connected failed"]
        redirect_to :action => 'error'
      end
    end

  end
  def error
    
  end
end
