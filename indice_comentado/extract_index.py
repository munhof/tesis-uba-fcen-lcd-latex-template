import re
import os

MANUSCRITO_DIR = "../manuscrito"
CHAPTERS_DIR = os.path.join(MANUSCRITO_DIR, "chapters")
MAIN_TEX = os.path.join(MANUSCRITO_DIR, "main.tex")
OUTPUT_FILE = "contenido.tex"

def get_included_files(main_tex_path):
    with open(main_tex_path, 'r', encoding='utf-8') as f:
        content = f.read()
    
    # Find the main matter section
    main_matter_match = re.search(r'\\mainmatter(.*?)\\backmatter', content, re.DOTALL)
    if not main_matter_match:
        # Fallback to whole content if mainmatter is not found
        search_area = content
    else:
        search_area = main_matter_match.group(1)
    
    # Find \input lines
    inputs = re.findall(r'\\input\{(.*?)\}', search_area)
    # Filter only chapter inputs if they don't have the path
    files = []
    for inp in inputs:
        if inp.startswith('./'): inp = inp[2:]
        # If it doesn't have a path, assume it's in chapters/ or handle it
        if '/' not in inp:
            path = os.path.join(MANUSCRITO_DIR, inp + ".tex")
        else:
            path = os.path.join(MANUSCRITO_DIR, inp + ".tex")
        
        if os.path.exists(path):
            files.append(path)
    return files

def parse_chapter(file_path):
    with open(file_path, 'r', encoding='utf-8') as f:
        content = f.read()
    
    # Regex to find commands
    # We look for \chapter, \section, \subsection and \comentario
    pattern = r'\\(chapter|section|subsection|comentario)\{(.*?)\}'
    matches = re.findall(pattern, content, re.DOTALL)
    
    output = []
    for cmd, text in matches:
        text = text.strip()
        if cmd == "comentario":
            output.append(f"\\comentario{{{text}}}")
        elif cmd == "chapter":
            output.append(f"\\section{{{text}}}") # Convert chapter to section for the index report
        elif cmd == "section":
            output.append(f"\\subsection{{{text}}}") # Downscale sections
        elif cmd == "subsection":
            output.append(f"\\subsubsection{{{text}}}") # Downscale subsections
            
    return output

def main():
    included_files = get_included_files(MAIN_TEX)
    all_content = []
    
    for file_path in included_files:
        all_content.extend(parse_chapter(file_path))
    
    with open(OUTPUT_FILE, 'w', encoding='utf-8') as f:
        f.write("\n\n".join(all_content))
    
    print(f"Generated {OUTPUT_FILE} with {len(all_content)} entries.")

if __name__ == "__main__":
    main()
