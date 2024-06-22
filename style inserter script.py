import os
import re

def parse_text_style_args(text_style_str):
    """Parses TextStyle arguments, handling various formats."""
    
    text_style_str = text_style_str.replace("TextStyle(", "").replace(")", "")
    args = []
    current_arg = ""
    paren_count = 0
    for char in text_style_str:
        if char == ',' and paren_count == 0:
            args.append(current_arg.strip())
            current_arg = ""
        else:
            current_arg += char
            if char == '(':
                paren_count += 1
            elif char == ')':
                paren_count -= 1
    args.append(current_arg.strip())

    kwargs = {}
    for arg in args:
        try:
            key, value = arg.split(":", 1)
            kwargs[key.strip()] = value.strip()
        except ValueError:
            pass

    return kwargs

def process_dart_file(filepath):
    try:
        with open(filepath, 'r', encoding='utf-8') as file:  # Try UTF-8 first
            content = file.read()
    except UnicodeDecodeError:
        with open(filepath, 'r', encoding='latin-1') as file:  # Fallback to latin-1
            content = file.read()

    pattern = r'TextStyle\s*\(([^)]*)\)'
    matches = re.findall(pattern, content)

    replacements = {}
    for match in matches:
        try:
            kwargs = parse_text_style_args(match)

            # Determine var1 based on fontSize
            font_size = float(kwargs.get('fontSize', 0))  
            var1 = 'titleLarge' if font_size > 30 else ('titleMedium' if 25 <= font_size <= 30 else ('titleSmall' if 20 <= font_size < 25 else 'bodyLarge') )
            var1 = 'bodyLarge' if 25 <= font_size < 25 else ('bodyMedium' if 15 <= font_size < 20 else ('bodySmall' if 10 <= font_size < 15 else 'displayLarge'))
           # Get var2 or default to empty string
            var2 = f'color: {kwargs.get("color", "")},' if 'color' in kwargs else ''

            # Build the replacement string with the "?"
            replacement = f"Theme.of(context).textTheme.{var1}?.copyWith({var2})"  # Added "?"
            replacements[match] = replacement
        except (ValueError, KeyError):
            pass  # Skip TextStyle if parsing or keys fail

    # Replace TextStyle instances
    for original, replacement in replacements.items():
        content = content.replace(f'TextStyle({original})', replacement)

    with open(filepath, 'w', encoding='utf-8') as file:
        file.write(content)

def main():
    lib_directory = 'lib' 
    for root, _, files in os.walk(lib_directory):
        for file in files:
            if file.endswith('.dart'):
                filepath = os.path.join(root, file)
                process_dart_file(filepath)

if __name__ == '__main__':
    main()
