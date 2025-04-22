from cs50 import get_string

text = get_string("Text: ")
l = 0
w = 1
s = 0
for char in text:
    if char.isalpha():
        l += 1
    elif char == ' ':
        w += 1
    elif char in ['.', '!', '?']:
        s += 1
grade = round(0.0588 * ((l / w) * 100) - 0.296 * ((s / w) * 100) - 15.8)
if grade >= 16:
    print("Grade 16+")
elif grade < 1:
    print("Before Grade 1")
else:
    print(f"Grade {grade}")
