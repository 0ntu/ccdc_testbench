Vagrant.configure("2") do |config|
  # config.vm.box = "generic/ubuntu2204"
  # config.vm.box = "generic/debian9"
  # config.vm.box = "centos/7"
  # config.vm.box = "generic/gentoo"
  config.vm.box = "generic/alpine318"
  # config.vm.box = "generic/opensuse42"
  # config.vm.box = "generic/arch"
  # config.vm.box = "nixbox/nixos"


  # Provision with a shell script
  config.vm.provision "shell", inline: <<-SHELL
    #!/usr/bin/env bash

    # Usernames taken from xato_net_usernames wordlist
    innocuous_users=( "derek" "chan" "buffalo" "tim" "qwert" "phillip" "movie" "jester" "donnie" "clinton" "sam" "harrison" "bishop" "toyota" "gateway" "cool" "cherry" "candy" "bigguy" "bernie" "ben" "duke" "brent" "smith" "princess" "magic" "homer" "lawrence" "ladies" "jerome" "flipper" "drew" "tomcat" "song" "parker" "latin" "julian" )
    admin_users=( "ada" "adah" "adair" "adalia" "adaline" "adalyn" "adam" "adan" "adara" "adda" "addi" "addia" "addie" )
    uid0_users=( "remo" "remy" "ren" "rena" "renae" "renata" )
    password="password"

    # Create users
    if command -v "useradd" 2>&1 /dev/null; then
      for user in "${innocuous_users[@]}"; do
        sudo useradd -c "User Account" -m -p "$password" -s "$(bash)" $user
      done
    else      # alpine doesn't have useradd
      for user in "${innocuous_users[@]}"; do
        sudo adduser --disabled-password --gecos "" $user
        echo "$user:$password" | chpasswd
      done
    fi
  SHELL
end
