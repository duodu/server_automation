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
    @instance = Instance.find(params[:id])
  end
  def command_send
    @instance = Instance.find(params[:id])
    @cmd = Command.find(params[:cmd_id])
  end
  def read_deploy
    require 'win32ole'
    @excel = WIN32OLE::new('excel.Application')
    @workbook = @excel.Workbooks.Open('E:/lib/deploy.xlsx')
    @worksheet = @workbook.Worksheets(1)
    @worksheet.Select
    
    end_row_line = @workbook.Worksheets(1).UsedRange.rows.Count
    
    @col = Array.new
    @ip = Array.new
    @user = Array.new
    i = 0
    line = 1
    while i < 6 && line <= end_row_line
      if @worksheet.Range("A#{line}").value == 'commom'
        @col[i] = line
        i += 1
      end
      line += 1
    end
    @col.each do |c|
      @ip << @worksheet.Range("A#{c-1}").value.split("/")[0]
      @user << @worksheet.Range("A#{c-1}").value.split("/")[1]
    end
    @workbook.close
    @excel.Quit
  end
end
