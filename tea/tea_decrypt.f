# Descifrado de 64 bits usando TEA.
# tea_block vive en memoria de datos y debe venir cargado antes de ejecutar.
# key vive en vault[4] y ya esta cargado por vault_mem.hex.
# delta es el registro read-only del ISA con valor 0x9E3779B9.

int tea_block[2];      # Bloque de 64 bits cargado en memoria: dos palabras.
vault[4] key;          # Ventana de 4 palabras hacia la boveda segura.

@secure(0xA9C1F)
func int tea_decrypt(int[] v){
    int v0 = v[0];       # Copia local de la primera palabra cifrada.
    int v1 = v[1];       # Copia local de la segunda palabra cifrada.
    int sum = delta << 5;    # Valor inicial equivalente a delta * 32.

    for (int i = 0; i += 1; i < 32) {
        v1 -= ((v0 << 4) + key[2]) ^ (v0 + sum) ^ ((v0 >> 5) + key[3]);    # Revierte la mezcla aplicada sobre v1.
        v0 -= ((v1 << 4) + key[0]) ^ (v1 + sum) ^ ((v1 >> 5) + key[1]);    # Revierte la mezcla aplicada sobre v0.
        sum -= delta;    # Retrocede el acumulador usando el registro delta.
    }

    v[0] = v0;    # Escribe la primera palabra descifrada.
    v[1] = v1;    # Escribe la segunda palabra descifrada.
    ret 0;        # Retorno convencional para indicar fin correcto.
}

# main no pertenece al algoritmo TEA.
# Solo invoca el descifrado sobre los datos que ya estan en memoria.
func void main(){
    tea_decrypt(tea_block);    # Descifra in-place el bloque cargado en RAM.
}
