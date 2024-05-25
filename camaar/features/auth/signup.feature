Feature: Sign up as a Student

    As an User
    I want to set a password for my account from the registration request email
    So that I can access the system


    Background: student has been added to the database
        Given the following student exist:
            | name                   | course               | registration | education     | occupation |
            | Ana Clara Jordao Perna | COMPUTER SCIENCE/CIC | 190084006    | undergraduate | student    |

    Scenario Outline: User has clicked on the registration link
        Given I