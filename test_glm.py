from zhipuai import ZhipuAI
import os

# Ganti dengan API key Anda
API_KEY = "f488669918bf4079872ce1034472a078.NM3tVMbgXiBq9qcG"
client = ZhipuAI(api_key=API_KEY)

class CodeAssistant:
    def __init__(self):
        self.conversation_history = [
            {
                "role": "system", 
                "content": """Anda adalah asisten pemrograman expert yang membantu memperbaiki dan mengoptimalkan kode.
                
Tugas Anda:
1. Menganalisis kode yang diberikan
2. Menemukan bug, error, atau masalah
3. Memberikan kode yang sudah diperbaiki
4. Menjelaskan apa yang diperbaiki dan mengapa
5. Memberikan saran untuk perbaikan lebih lanjut

Format respons Anda:
- Jelaskan masalah yang ditemukan
- Berikan kode yang sudah diperbaiki
- Jelaskan perubahan yang dilakukan
- Berikan tips tambahan jika ada"""
            }
        ]
    
    def review_code(self, code, issue_description=""):
        """Review dan perbaiki kode"""
        prompt = f"""Tolong review dan perbaiki kode berikut:

```python
{code}
```
"""
        if issue_description:
            prompt += f"\nMasalah yang dihadapi: {issue_description}"
        
        self.conversation_history.append({"role": "user", "content": prompt})
        
        response = client.chat.completions.create(
            model="glm-4",
            messages=self.conversation_history,
            temperature=0.3,  # Lebih rendah untuk hasil yang lebih konsisten
            max_tokens=2000
        )
        
        assistant_message = response.choices[0].message.content
        self.conversation_history.append({"role": "assistant", "content": assistant_message})
        
        return assistant_message
    
    def ask_followup(self, question):
        """Tanya pertanyaan lanjutan tentang kode"""
        self.conversation_history.append({"role": "user", "content": question})
        
        response = client.chat.completions.create(
            model="glm-4",
            messages=self.conversation_history,
            temperature=0.3
        )
        
        assistant_message = response.choices[0].message.content
        self.conversation_history.append({"role": "assistant", "content": assistant_message})
        
        return assistant_message
    
    def explain_code(self, code):
        """Jelaskan cara kerja kode"""
        prompt = f"""Jelaskan cara kerja kode ini secara detail:

```python
{code}
```"""
        
        return self.ask_followup(prompt)
    
    def optimize_code(self, code):
        """Optimasi kode untuk performa lebih baik"""
        prompt = f"""Optimasi kode berikut untuk performa dan efisiensi yang lebih baik:

```python
{code}
```"""
        
        return self.ask_followup(prompt)


def read_file(filename):
    """Baca kode dari file"""
    try:
        with open(filename, 'r', encoding='utf-8') as f:
            return f.read()
    except FileNotFoundError:
        print(f"File {filename} tidak ditemukan!")
        return None


def interactive_mode():
    """Mode interaktif untuk chat dengan AI"""
    print("=" * 60)
    print("GLM-4 Code Assistant - Mode Interaktif")
    print("=" * 60)
    print("Perintah:")
    print("  1. Ketik/paste kode Anda, lalu tekan Enter 2x")
    print("  2. 'file:namafile.py' - Review kode dari file")
    print("  3. 'exit' - Keluar")
    print("=" * 60)
    
    assistant = CodeAssistant()
    
    while True:
        print("\n📝 Masukkan kode Anda (atau perintah):")
        print("   (Tekan Enter 2x untuk selesai, atau ketik perintah)")
        
        # Baca input
        first_line = input().strip()
        
        if first_line.lower() == 'exit':
            print("Terima kasih! Sampai jumpa!")
            break
        
        # Cek apakah input adalah file
        if first_line.startswith('file:'):
            filename = first_line[5:].strip()
            code = read_file(filename)
            if code is None:
                continue
        else:
            # Baca multi-line input
            lines = [first_line]
            while True:
                line = input()
                if line == "":
                    if lines and lines[-1] == "":
                        break
                lines.append(line)
            code = "\n".join(lines).strip()
        
        if not code:
            print("❌ Tidak ada kode yang dimasukkan!")
            continue
        
        # Tanya apakah ada masalah spesifik
        print("\n💬 Ada masalah spesifik? (Enter untuk skip):")
        issue = input().strip()
        
        # Review kode
        print("\n🔍 Menganalisis kode...\n")
        print("=" * 60)
        result = assistant.review_code(code, issue)
        print(result)
        print("=" * 60)
        
        # Mode tanya jawab lanjutan
        while True:
            print("\n💭 Pertanyaan lanjutan? (Enter untuk kode baru, 'exit' untuk keluar):")
            follow_up = input().strip()
            
            if not follow_up:
                break
            if follow_up.lower() == 'exit':
                print("Terima kasih! Sampai jumpa!")
                return
            
            print("\n" + "=" * 60)
            answer = assistant.ask_followup(follow_up)
            print(answer)
            print("=" * 60)


def quick_review():
    """Mode quick review - langsung review kode"""
    print("=" * 60)
    print("GLM-4 Code Assistant - Quick Review")
    print("=" * 60)
    
    # Contoh kode dengan bug
    sample_code = """
def calculate_average(numbers):
    total = 0
    for num in numbers:
        total += num
    return total / len(numbers)

# Test
data = [1, 2, 3, 4, 5]
print(calculate_average(data))
print(calculate_average([]))  # Bug: division by zero
"""
    
    print("\n📋 Contoh kode dengan bug:")
    print(sample_code)
    
    assistant = CodeAssistant()
    print("\n🔍 Menganalisis kode...\n")
    print("=" * 60)
    result = assistant.review_code(sample_code, "Kode ini error saat list kosong")
    print(result)
    print("=" * 60)


def main():
    print("\n🤖 GLM-4 Code Assistant")
    print("Pilih mode:")
    print("1. Mode Interaktif (chat dengan AI)")
    print("2. Quick Review (contoh cepat)")
    
    choice = input("\nPilihan (1/2): ").strip()
    
    if choice == "1":
        interactive_mode()
    elif choice == "2":
        quick_review()
    else:
        print("Pilihan tidak valid!")


if __name__ == "__main__":
    try:
        main()
    except KeyboardInterrupt:
        print("\n\nProgram dihentikan. Terima kasih!")
    except Exception as e:
        print(f"\n❌ Error: {e}")
        print("\nPastikan:")
        print("1. API key sudah benar")
        print("2. Library zhipuai sudah terinstall")
        print("3. Koneksi internet aktif")