import argparse
import os

def get_output_path(filename):
    current_dir = os.path.dirname(os.path.abspath(__file__))
    target_dir = os.path.normpath(os.path.join(current_dir, "..", "memories"))
    if not os.path.exists(target_dir):
        os.makedirs(target_dir)
    return os.path.join(target_dir, filename)

def main():
    parser = argparse.ArgumentParser(description='Carga archivos a memoria Verilog')
    parser.add_argument('--input', required=True, help='Archivo de entrada')
    parser.add_argument('--output', required=True, help='Nombre del archivo .hex de salida')
    parser.add_argument('--address', required=True, help='Dirección inicial en hex (ej: 0x1000)')
    
    args = parser.parse_args()
    
    # Manejo de dirección
    start_addr = int(args.address, 16)
    word_addr = start_addr // 4  # Dirección base en palabras de 32 bits
    
    if not os.path.exists(args.input):
        print(f"Error: El archivo {args.input} no existe.")
        return

    with open(args.input, 'rb') as f:
        data = f.read()
    
    file_size = len(data)
    output_path = get_output_path(args.output)

    print(f"--- Cargando Archivo ---")
    print(f"Origen: {args.input} ({file_size} bytes)")
    print(f"Destino: {output_path}")
    print(f"Rango: {hex(start_addr)} -> {hex(start_addr + file_size - 1)}")

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
python load_file.py --input ../files/bedrock.png --output ../memories/data_mem.hex --address 0x0
"""