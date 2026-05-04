import argparse
import os
import re

def main():
    parser = argparse.ArgumentParser(description='Carga Universal: Texto Hex o Binario')
    parser.add_argument('--input', required=True, help='Archivo de entrada')
    parser.add_argument('--output', required=True, help='Archivo .hex de salida')
    parser.add_argument('--address', required=True, help='Dirección inicial hex')
    
    args = parser.parse_args()
    start_addr = int(args.address, 16)
    word_addr = start_addr // 4
    
    if not os.path.exists(args.input):
        print(f"Error: {args.input} no existe.")
        return

    # Leemos todo como binario para decidir
    with open(args.input, 'rb') as f:
        raw_content = f.read()

    words = []

    # --- INTENTO DE LECTURA COMO TEXTO HEX ---
    try:
        # Intentamos decodificar. Si falla, es binario puro (como una imagen).
        text_content = raw_content.decode('utf-8')
        
        # Si el texto tiene saltos de línea y caracteres hex, procesamos como instrucciones
        if any(c in text_content for c in '\n\r') and re.search(r'[0-9a-fA-F]{4,}', text_content):
            print(">>> Modo: TEXTO HEXADECIMAL (Instrucciones)")
            lines = text_content.splitlines()
            for line in lines:
                # 1. Eliminar comentarios //
                clean = line.split('//')[0]
                # 2. Eliminar @ y lo que le siga en esa palabra, y limpiar espacios
                clean = re.sub(r'@\S*', '', clean).strip()
                
                if not clean:
                    continue
                
                # 3. Extraer palabras hex (maneja múltiples palabras por línea)
                hex_words = re.findall(r'[0-9a-fA-F]+', clean)
                for hw in hex_words:
                    words.append(int(hw, 16))
        else:
            raise ValueError("No parece texto hex")

    except (UnicodeDecodeError, ValueError):
        # --- MODO BINARIO PURO (Imágenes, etc.) ---
        print(">>> Modo: BINARIO PURO (Imagen/Datos)")
        for i in range(0, len(raw_content), 4):
            chunk = raw_content[i:i+4]
            if len(chunk) < 4:
                chunk = chunk + b'\x00' * (4 - len(chunk))
            # Little Endian (Byte 0 es LSB)
            word = (chunk[3] << 24) | (chunk[2] << 16) | (chunk[1] << 8) | chunk[0]
            words.append(word)

    # --- ESCRITURA ---
    output_dir = os.path.dirname(args.output)
    if output_dir and not os.path.exists(output_dir):
        os.makedirs(output_dir)

    with open(args.output, 'w') as f:
        f.write(f"@{word_addr:08x}\n")
        for w in words:
            f.write(f"{w:08x}\n")

    print(f"Hecho: {len(words)} palabras escritas en {args.output}")

if __name__ == "__main__":
    main()


"""
python src/load_file.py --input input/prueba1.hex --output src/instrmem/instr_mem.hex --address 0x0
"""