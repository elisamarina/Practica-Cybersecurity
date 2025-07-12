# --- Ex1: Generează chei SSH ---

ssh-keygen -t rsa -b 4096 -f ./id_rsa_tema -N ""

# ---Ex2: Criptează un fișier ---

echo "IBM practice" > hashing.txt

openssl rand -out cheie.bin 16
openssl rand -out iv.bin 16

CHIA_HEX=$(xxd -p -c 256 cheie.bin)
IV_HEX=$(xxd -p -c 256 iv.bin)

openssl enc -aes-128-cfb -in hashing.txt -out hashing_cfb.enc -K "$CHIA_HEX" -iv "$IV_HEX"

openssl enc -aes-128-ecb -in hashing.txt -out hashing_ecb.enc -K "$CHIA_HEX"


# --- Verifică decriptarea ---

openssl enc -d -aes-128-cfb -in hashing_cfb.enc -K "$CHIA_HEX" -iv "$IV_HEX"
