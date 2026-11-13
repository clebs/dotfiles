# How to add secrets

First create a secret file in a given path using age. Age reads from given file or stdin.

```bash
# each -r is a receipient public key
# To use receipient key files use -R ~/.ssh/id_XXX.pub
age -r "ssh-ed25519 AAAA..." -r "ssh-ed25519 AAAA..." -o my-secret.age my-secret.txt

# To edit secrets on editor use agenix
agenix -e my-secret.age

```

Then setup nix to be able to decrypt the secrets:
```nix
   # secrets/secrets.nix
   let
     borja = "ssh-ed25519 AAAA...";  # your public key
     receipient2 = "ssh-ed25519 AAAA..."; #  other receipient key
   in {
     "my-secret.age".publicKeys = [ borja receipient2 ];
   }
```

Finally tell nix where to put the secret at build time with owner and permissions
```nix
   age.secrets.some-secret = {
     file = ./secrets/my-secret.age;
     owner = "borja";
     group = "borja";
     mode = "0600"; # Only owner can read or write
     path = "/etc/my/secret.conf";
   };
 ```
