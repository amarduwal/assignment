## Number to possible words conversion
Given a 10 digit phone number, you should return all possible words or combinations of words from the provided dictionary, that can be mapped back as a whole to the number.
With this we can generate numbers like 1-800-motortruck which is easier to remember than 1-800-6686787825.
The phone number mapping to letters is as follows:
2 = a b c
3 = d e f
4 = g h i
5 = j k l
6 = m n o
7 = p q r s
8 = t u v
9 = w x y z
The phone numbers will never contain a 0 or 1.
Words have to be at least 3 characters.

To give you an initial idea, here are some numbers that return (a lot of) results.
6686787825 returns a (long) list with at least these word combinations:
* motortruck
* motor, truck
* motor, usual
* noun, struck
* not, opt, puck

2282668687 returns a (long) list with at least these word combinations:
* catamounts
* acta, mounts
* act, amounts
* act, contour
* cat, boot, our

The conversion of a 10 digit phone number should be performed within 1000ms.