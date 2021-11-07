# crypto_solidity

Схема алгоритма тут 
https://miro.com/app/board/o9J_llMbqyY=/?invite_link_id=913984598901

**Как сгенерировать commitment:**  
in shell:  
```
pip3 install web3
```

in python3:
```
import web3
web3.Web3.solidityKeccak(['string', 'string'], ['paper', 'password12345'])
HexBytes('0xb0c1f97a3a2b7f321dcef007069b5aa7b7d8f608e59fac217519f6fd4450076c')
```


