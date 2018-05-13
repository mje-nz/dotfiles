# Fast file copies
# Based on https://gist.github.com/KartikTalwar/4393116
# Cipher list from https://hihn.org/post/openssh-ciphers-performance-benchmark/
alias rcp='rsync -aHAXxv --numeric-ids --no-i-r --info=progress2 -e "ssh -T -c chacha20-poly1305@openssh.com,aes192-cbc -o Compression=no -x"'

