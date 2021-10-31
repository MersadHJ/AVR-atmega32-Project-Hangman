# Project Hangman

Project Hangman is a word guessing game in which a word is chosen by computer and the player have to guess what the word is.
This project is implemented using C language for AVR atmega 32 as our final project for microprocessor course.

## Team Members

+ [Nami Naziri](https://github.com/NamiNaziri)

+ [Mersad Hassanjani](https://github.com/MersadHassanjani)

## Project Details

Firstly, the player have to choose a category. There are four categories (sports, movies, countries and computer science related words). Then a word will be chosen from our database of words. There are currently 20 words for each category and new words can be added through the code.

There are two LCDs. The first one is used for showing categories and words. The second one is used for showing player's score and the number of chanses the player have.
In addition since the keypad we were using did not have any alphabetic word we had to use the second LCD for showing alphabet too.

When the player wants to guess the word he will use the key pad and by pressing any number on that, series of alphabet will be shown on the second LCD and by pressing again the selected alphabet will get registered. 

## Rules

For each word the player has 3 chances and if he can not find the word in those chases the game will get restarted. 
When the player guess the word currectly, his/her chances get reset.
For each word that the player guess, he/she gets a score.

## implementation

For each word that is to be guessed we have an integer array of 26 which is equal to the number of alphabets. So whenever a word is chosen, the array's index corresponding to alphabets in that word will get the value of one. And when the player guess the alphabet currectly, the corresponding index of that will get the value of two.
If all of the one's turn into two, the player guessed the word currectly.


https://user-images.githubusercontent.com/49837425/139583004-5184c4ea-865e-4cb0-8861-b32ee1b83892.mp4



