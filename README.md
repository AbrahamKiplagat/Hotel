# Hotel Management System
- This repository contains the source code for a hotel management app built using Flutter.
-  The app provides comprehensive management features for hotel administrators and users.
-  Administrators can manage rooms, bookings, and user accounts, while users can make bookings, view their reservations, and provide feedback.
-  The app includes authentication functionality for both admins and users, ensuring secure access to the app's features.
-  It offers a user-friendly interface, smooth navigation, and seamless integration with backend services.
-   Whether you're a hotel owner looking to streamline operations or a traveler seeking a convenient booking experience, this app serves as an efficient solution for managing hotel activities.
# Description
- This is a hotel booking application built with Flutter.
- It allows users to search for hotels, view hotel details, and make bookings.

## Abstract

This documentation provides a comprehensive overview of the development and functionality of a hotel booking website. The project is designed to offer users an intuitive and seamless experience for searching, selecting, and booking hotel accommodations. Key features include a user-friendly interface, advanced search and filter options, secure payment processing, and robust administrative tools for hotel management.

The system architecture leverages modern web technologies to ensure scalability, reliability, and responsiveness. This documentation covers the technical specifications, implementation details, and user guides necessary to understand and utilize the hotel booking platform effectively.

## Declaration

I, Abraham Kiplagat, a student of the Institute of Software Development, hereby declare that the project entitled "Hotel Management System" is my original work and has not been submitted for any other degree or examination.

I further declare that to the best of my knowledge and belief, the content of this project does not infringe the intellectual property rights of any other person belonging to the diploma Software Development day class.

I understand that any act of plagiarism or academic dishonesty, as defined by Institute of Software Development regulations, will result in severe penalties.

Signed,

Abraham Kiplagat.

## Problem Statement

The process of booking hotel accommodations can often be cumbersome and inefficient for travelers. Traditional booking methods and some existing online platforms lack user-friendly interfaces, comprehensive search capabilities, and real-time availability updates. These issues can lead to user frustration, wasted time, and potential revenue loss for hotels due to booking errors and double bookings. Additionally, hotel administrators face challenges in managing reservations, inventory, and customer data efficiently.

## Proposed Solutions

This project proposes the development of a robust hotel booking website designed to streamline the booking process for users while providing powerful management tools for hotel administrators. The platform will feature an intuitive user interface that allows travelers to effortlessly search for hotels based on regions.

For hotel administrators, the website will include a comprehensive management dashboard to handle reservations, monitor room inventory, and manage customer data efficiently. Secure payment processing and automated confirmation systems will reduce the risk of booking errors and enhance user trust. By integrating these features, the proposed solution aims to create a seamless and efficient booking experience for users and a powerful management tool for hoteliers.

## Entity-Relationship Diagram (ERD)

```mermaid
erDiagram
    USER {
        string user_id
        string first_name
        string last_name
        string email
        string password
    }

    HOTEL {
        string hotel_id
        string name
        string location
        string description
    }

    ROOM {
        string room_id
        string hotel_id
        string room_type
        string price
        boolean availability
    }

    BOOKING {
        string booking_id
        string user_id
        string room_id
        date check_in_date
        date check_out_date
        string payment_status
    }

    PAYMENT {
        string payment_id
        string booking_id
        float amount
        date payment_date
        string payment_method
    }

    USER ||--o{ BOOKING : "makes"
    BOOKING ||--o{ PAYMENT : "has"
    HOTEL ||--o{ ROOM : "contains"
    ROOM ||--o{ BOOKING : "reserved in"
