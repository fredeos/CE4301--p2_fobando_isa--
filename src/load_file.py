import argparse
import math
import mimetypes
import os

def get_output_path(filename):
    current_dir = os.path.dirname(os.path.abspath(__file__))
    # target_dir = os.path.normpath(os.path.join(current_dir, "..", "memories"))
    # if not os.path.exists(target_dir):
    #     os.makedirs(target_dir)
    return os.path.join(current_dir, filename)

def main():
    parser = argparse.ArgumentParser(description='Carga archivos a memoria Verilog')
    parser.add_argument('--input', required=True, help='Archivo de entrada')
    parser.add_argument('--output', required=True, help='Nombre del archivo .hex de salida')
    parser.add_argument('--address', required=True, help='Dirección inicial en hex (ej: 0x1000)')
    
    args = parser.parse_args()
    
    # Manejo de dirección
    start_addr = int(args.address, 16)
    if start_addr % 4 != 0:
        raise SystemExit("Error: la dirección inicial debe estar alineada a 4 bytes.")
    word_addr = start_addr // 4  # Dirección base en palabras de 32 bits
    
    if not os.path.exists(args.input):
        print(f"Error: El archivo {args.input} no existe.")
        return

    with open(args.input, 'rb') as f:
        data = f.read()
    
    file_size = len(data)
    detected_type = mimetypes.guess_type(args.input)[0] or "application/octet-stream"
    words = math.ceil(file_size / 4)
    tea_blocks = math.ceil(file_size / 8)
    padded_size = tea_blocks * 8
    output_path = get_output_path(args.output)

    print(f"--- Cargando Archivo ---")
    print(f"Origen: {args.input}")
    print(f"Tipo detectado: {detected_type}")
    print(f"Tamaño: {file_size} bytes")
    print(f"Destino: {output_path}")
    print(f"Dirección inicial: {hex(start_addr)}")
    print(f"Rango usado por archivo: {hex(start_addr)} -> {hex(start_addr + file_size - 1)}")
    print(f"Palabras de 32 bits escritas: {words}")
    print(f"Bloques TEA de 64 bits: {tea_blocks}")
    print(f"Rango TEA con padding: {hex(start_addr)} -> {hex(start_addr + padded_size - 1)}")
    print(f"Padding final para TEA: {padded_size - file_size} bytes")

    with open(output_path, 'w') as f:
        # El prefijo @ indica a $readmemh en qué índice de palabra empezar
        f.write(f"@{word_addr:08x}\n")
        
        for i in range(0, file_size, 4):
            chunk = data[i:i+4]
            # Relleno con ceros para completar la palabra de 32 bits
            if len(chunk) < 4:
                chunk = chunk + b'\x00' * (4 - len(chunk))
            
            # Little Endian: El primer byte es el menos significativo
            word = (chunk[3] << 24) | (chunk[2] << 16) | (chunk[1] << 8) | chunk[0]
            f.write(f"{word:08x}\n")

    print("Carga completada exitosamente.")

if __name__ == "__main__":
    main()

"""
python load_file.py --input ../input/bedrock.png --output ./datamem/data_mem.hex --address 0x0
"""
