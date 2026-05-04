# Cifrado de 64 bits usando TEA.
# tea_block vive en memoria de datos y debe venir cargado antes de ejecutar.
# key vive en vault[4] y ya esta cargado por vault_mem.hex.
# delta es el registro read-only del ISA con valor 0x9E3779B9.

int tea_block[2];      # Bloque de 64 bits cargado en memoria: dos palabras.
vault[4] key;          # Ventana de 4 palabras hacia la boveda segura.

@secure(0xA9C1F)
func int tea_encrypt(){
    int v0 = tea_block[0];       # Copia local de la palabra baja del bloque.
    int v1 = tea_block[1];       # Copia local de la palabra alta del bloque.
    int sum = 0;         # Acumulador de rondas de TEA.

    for (int i = 0; i += 1; i < 32) {
        sum += delta;    # Avanza el acumulador usando el registro delta.
        v0 += ((v1 << 4) + key[0]) ^ (v1 + sum) ^ ((v1 >> 5) + key[1]);    # Mezcla v1 con key[0] y key[1].
        v1 += ((v0 << 4) + key[2]) ^ (v0 + sum) ^ ((v0 >> 5) + key[3]);    # Mezcla v0 actualizado con key[2] y key[3].
    }

    tea_block[0] = v0;    # Escribe la primera palabra cifrada.
    tea_block[1] = v1;    # Escribe la segunda palabra cifrada.
    ret 0;        # Retorno convencional para indicar fin correcto.
}

# main no pertenece al algoritmo TEA de la figura.
# Solo invoca el cifrado sobre los datos que ya estan en memoria.
func void main(){
    tea_encrypt();    # Cifra in-place el bloque cargado en RAM.
}
