<div align="center">
<img src="./images/bookshifter_logo.png" height="100" />
  <h3 align="center">BookShifter</h3>

  <p align="center">
  <b>2nd place project</b> of the <a href="https://shiftappens.com">Shift APPens Hackathon</a> 10th edition.
  </p>
    <a href="https://shiftappens.com">
    <img src="./images/shiftappens_logo.png" height="50" />
  </a>
  <img src="./images/award.png" height="50" />
</div>

## Team

Four students from two different universities, with different backgrounds.

<image src="./images/team.jpg" height="200">

- [Linda Albuquerque](https://github.com/linda0ima) MDM - FCTUC (Coimbra)
- [João Torre Pereira](https://github.com/thePeras) L.EIC - FEUP (Porto)
- [Diogo Fernandes](https://github.com/diogotvf7) L.EIC - FEUP (Porto)
- [Rafael David](https://github.com/o-rafaeldavid) MDM - FCTUC (Coimbra)

## Problem

Neck strain experienced when reading vertically aligned book spines in a bookstore or library.

<img src="./images/dog.gif" height="100"/>

## Solution: BookShifter

An immersive experience, allowing users to scan books and access their information instantly, eliminating the need to remove books from the shelf.

The full submitted description can be found [here](docs/taikai_description.md).

https://github.com/user-attachments/assets/8f0eaebf-80ca-4ddb-accd-30fc005432ec

## Technologies

We scratched our idea in **Figma**, check the final designs at the design folder, and implemented everything in **Flutter**.
The books and their text recognition were made with the **Amazon Rekognition API** and all the book data was fetched from the **Google Books API**.

## How to run the project

To run the project, you need to have Flutter installed. If you don't have it installed, you can follow the instructions [here](https://flutter.dev/docs/get-started/install).

After you have Flutter installed, you can clone the repository.

To use Rekognition API, create an access key by entering into your AWS account, search IAM and set up a new user. In the created user security credentials, create a new access key. Copy the access key and secret key and paste them .env file of app folder.

```bash
PUBLIC=your_access_key
SECRET=your_secret_key
```

Start the application by running the following commands in the project root directory:

```bash
flutter pub get
flutter run
```
