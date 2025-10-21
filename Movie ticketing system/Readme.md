# Movie Ticket Booking Platform — README

Brief
---
Develop a Movie Ticket Booking Platform that enables users to sign up, browse movies and shows, select seats, and book tickets. The system must support automated show generation (with seat initialization and dynamic seat pricing), theatre and movie management, and basic booking/cancellation flows.

System components
---
- User Management
- Movie Management
- Theatre Management
- Show Management
- Booking Management
- Optional (Bonus): user booking history and cancellation

Commands and behavior
---
1) User Registration
- Command: `CreateUser <user_name>`
- Description: Creates a user with an auto-incremented ID starting from 1. User names must be unique.
- Example:
    - `CreateUser John`

2) Movie Management
- Add a movie:
    - Command: `AddMovie <movie_name>`
    - Description: Adds a movie with an auto-incremented ID starting from 1.
    - Example:
        - `AddMovie Final-Destination`
- List movies:
    - Command: `ListMovie`
    - Description: Lists all available movies.
    - Example:
        - `ListMovie`

3) Theatre Management
- Command: `AddTheatre <theatre_name> <num_normal_seats> <num_premium_seats> <base_seat_price>`
- Description: Adds a theatre with an auto-incremented ID starting from 1, specifying counts for normal and premium seats and a base seat price.
- Example:
    - `AddTheatre PVR 20 5 100`

4) Show Generation
- Command: `GenerateShows <movie_id|movie_name> <theatre_id|theatre_name> <number_of_shows>`
- Description:
    - Generates the specified number of shows for the given movie in the specified theatre for a single day.
    - Each show is assigned a show type randomly from {morning, afternoon, evening}.
    - Each show contains: movie details, theatre details, show type, seat information with calculated prices, and unique show ID.
- Example:
    - `GenerateShows 1 1 3`
- Notes:
    - There will be at most one movie per timeslot (morning/afternoon/evening) for that theatre/day.
    - On show generation, seats are initialized and priced according to pricing rules below.

Pricing rules
---
- Base seat price is provided at theatre creation.
- Show type surcharges (added to base price):
    - Morning: +50
    - Afternoon: +70
    - Evening: +90
- Seat type surcharges (added after show type surcharge):
    - Normal seat: +20
    - Premium seat: +40
- Seat price = base_seat_price + show_type_surcharge + seat_type_surcharge

5) List Shows
- Command: `ListShows <movie|theatre> <movie_id|theatre_id>`
- Description: Lists all shows for a movie or all shows in a theatre. First argument is the mode (`movie` or `theatre`) followed by the id.
- Example:
    - `ListShows movie 1`
    - `ListShows theatre 1`

6) Book Ticket
- Command: `BookTicket <user_id> <show_id> <seat_list>`
- Description:
    - Checks seat availability and books the requested seats for the user.
    - Seat list format: `[1,2,3]` (IDs or seat numbers as defined by the show).
- Example:
    - `BookTicket 1 1 [1,2]`

7) Cancellation and History (Bonus)
- List all tickets booked by a user:
    - Command: `ListTickets <user_id>`
    - Description: Shows all active bookings for the given user.
- Cancel a booking:
    - Command: `CancelTicket <user_id> <booking_id>`
    - Description: Cancels the specified booking if owned by the user and frees seats.

Data and ID conventions
---
- All entities (users, movies, theatres, shows, bookings) use auto-incremented integer IDs starting from 1.
- Seat numbering per show should be stable and unique within that show (e.g., sequential integers, with metadata for type: Normal/Premium).

Examples workflow
---
1. `CreateUser Alice` -> User created (id=1)  
2. `AddMovie Inception` -> Movie created (id=1)  
3. `AddTheatre PVR 20 5 100` -> Theatre created (id=1)  
4. `GenerateShows 1 1 3` -> Creates up to 3 shows for movie 1 in theatre 1 (morning/afternoon/evening)  
5. `ListShows movie 1` -> Displays shows for movie 1 with seat maps and prices  
6. `BookTicket 1 2 [1,2]` -> Books seats 1 and 2 in show 2 for user 1  
7. `ListTickets 1` -> Shows bookings for user 1  
8. `CancelTicket 1 1` -> Cancels booking 1 for user 1

Notes and constraints
---
- Input validation is required: ensure referenced IDs exist, seat indices are in range, usernames are unique.
- Concurrency: on booking, perform atomic seat availability checks to avoid double booking.
- Shows are generated per theatre per day; the scope here is a single-day generation model.
- Extendable: support multi-day schedules, pricing rules by special show types, and discounts in future iterations.

Contact / Contribution
---
- Implementations should map commands to functions or a CLI parser and persist state in a simple in-memory model or a lightweight datastore for testing.
