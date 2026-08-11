{ inputs, config, ... }:

{
  flake.nixosModules.impermanence = { ... }: {
    boot.initrd.systemd = {
      enable = true;
      services.rollback = {
        description = "Rollback BTRFS root subvolume to a pristine state";
        wantedBy = [ "initrd.target" ];

        # LUKS/TPM process.
        after = [ "systemd-cryptsetup@enc.service" ];

        # Before mounting the system root (/sysroot) during the early boot process
        before = [ "sysroot.mount" ];

        unitConfig.DefaultDependencies = "no";
        serviceConfig.Type = "oneshot";
        script = ''
          mkdir -p /btrfs_tmp

          # Mount the BTRFS top-level subvolume.
          mount -o subvolid=5 /dev/mapper/enc /btrfs_tmp

          delete_subvolume_recursively() {
              local subvolume="$1"

              while IFS= read -r subvolume_path; do
                  delete_subvolume_recursively "/btrfs_tmp/$subvolume_path"
              done < <(
                  btrfs subvolume list -o "$subvolume" |
                  cut -f 9- -d ' '
              )

              echo "deleting $subvolume..."
              btrfs subvolume delete "$subvolume"
          }

          # Archive the existing root.
          if [[ -e /btrfs_tmp/root ]]; then
              mkdir -p /btrfs_tmp/old_roots

              timestamp=$(date \
                  --date="@$(stat -c %Y /btrfs_tmp/root)" \
                  "+%Y-%m-%-d_%H:%M:%S")

              echo "moving /root to /old_roots/$timestamp..."
              mv /btrfs_tmp/root "/btrfs_tmp/old_roots/$timestamp"
          fi

          # Delete archived roots older than 30 days.
          while IFS= read -r old_root; do
              delete_subvolume_recursively "$old_root"
          done < <(
              find /btrfs_tmp/old_roots/ \
                  -mindepth 1 \
                  -maxdepth 1 \
                  -mtime +30 \
                  -print
          )

          # Create a new empty root.
          echo "creating new /root subvolume..."
          btrfs subvolume create /btrfs_tmp/root

          umount /btrfs_tmp
        '';
      };
    };

    imports = [ inputs.impermanence.nixosModules.impermanence ];

    users.users."${config.username}".hashedPasswordFile = "/persist/passwords/${config.username}";

    environment.persistence."/persist" = {
      directories = [
        "/etc/nixos"
        "/etc/secureboot"
        "/var/lib/nixos"
        "/var/lib/libvirt"
      ];

      files = [
        "/etc/machine-id"

        # Required for SSH.
        "/etc/ssh/ssh_host_ed25519_key"
        "/etc/ssh/ssh_host_ed25519_key.pub"
        "/etc/ssh/ssh_host_rsa_key"
        "/etc/ssh/ssh_host_rsa_key.pub"
      ];
    };
  };
}
