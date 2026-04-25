import argparse
import os

def get_input_path(filename):
    current_dir = os.path.dirname(os.path.abspath(__file__))
    return os.path.normpath(os.path.join(current_dir, "..", "memories", filename))

def main():
    parser = argparse.ArgumentParser(description='Extrae datos de memoria a binario')
    parser.add_argument('--memory', required=True, help='Archivo de volcado (.hex/.txt)')
    parser.add_argument('--address', required=True, help='Dirección inicial en hex')
    parser.add_argument('--size', type=int, required=True, help='Tamaño en bytes a extraer')
    parser.add_argument('--output', required=True, help='Nombre del archivo de salida')

    args = parser.parse_args()
    
    mem_path = get_input_path(args.memory)
    start_addr = int(args.address, 16)
    word_start = start_addr // 4
    num_words = (args.size + 3) // 4 # Cuántas palabras cubrir

    if not os.path.exists(mem_path):
        print(f"Error: No se encuentra el archivo de memoria en {mem_path}")
        return

    extracted_bytes = bytearray()
    
    with open(mem_path, 'r') as f:
        # Ignorar líneas de dirección (@) y espacios
        lines = [l.strip() for l in f if l.strip() and not l.startswith('@')]
        
        # Extraer el segmento solicitado
        target_words = lines[word_start : word_start + num_words]
        
        for hex_word in target_words:
            val = int(hex_word, 16)
            # Descomponer de 32-bit word a bytes (Little Endian)
            extracted_bytes.append(val & 0xFF)
            extracted_bytes.append((val >> 8) & 0xFF)
            extracted_bytes.append((val >> 16) & 0xFF)
            extracted_bytes.append((val >> 24) & 0xFF)

    # El output final se guarda en la carpeta actual o donde especifiques
    with open(args.output, 'wb') as f:
        f.write(extracted_bytes[:args.size])
    
    print(f"--- Extracción Completada ---")
    print(f"Archivo de memoria consultado: {args.memory}")
    print(f"Bytes guardados en: {args.output}")

if __name__ == "__main__":
    main()


"""
python extract_data.py --memory ../memories/data_mem.hex --address 0x0 --size 247 --output ../test_files/bedrock_recuperada.png
"""