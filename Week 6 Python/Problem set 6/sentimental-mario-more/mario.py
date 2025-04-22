def main():
    height = get_int("Height: ")

    for row in range(height):
        print(" " * (height - row - 1), end="")
        print("#" * (row + 1), end="  ")
        print("#" * (row + 1))


def get_int(s):
    while (True):
        try:
            a = int(input(s))
            if 0 < a < 9:
                return a
        except:
            pass


main()
