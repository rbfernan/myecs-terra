#
# Cookbook Name:: test
# Recipe:: default
#
#
#TODO Get version from env variables and set file names

directory '/opt/ecs-terra' do
    owner 'root'
    group 'root'
    mode '0755'
    action :create
end

bash 'Install required linux packages' do
    user 'root'
    cwd '/tmp'
    code <<-EOH
    sudo apt-get update -y
    sudo apt install -y unzip
    EOH
end

bash 'Install Terraform' do
    user 'root'
    cwd '/tmp'
    code <<-EOH
    echo ""
    echo "Downloading Terraform zip'd binary"    
    INSTALL_TRF_DIR="/usr/bin"
    DOWNLOADED_FILE="terraform_0.12.2_linux_amd64.zip"
    DOWNLOAD_URL="https://releases.hashicorp.com/terraform/0.12.2/$DOWNLOADED_FILE"
    curl -o "$DOWNLOADED_FILE" "$DOWNLOAD_URL"
    echo ""
    echo "Extracting Terraform executable"
    unzip "$DOWNLOADED_FILE" -d "$INSTALL_TRF_DIR"
    rm "$DOWNLOADED_FILE"
    EOH
 end

bash 'Install Docker' do
    user 'root'
    cwd '/tmp'
    code <<-EOH
    sudo apt-get update -y
    sudo apt install -y docker.io
    sudo systemctl start docker
    sudo systemctl enable docker
    EOH
end