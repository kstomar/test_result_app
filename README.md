# Result Analyzer App

This app works with test results and performs end of day (EOD) and Monthly Calculations

## Dependencies

### Ruby and Rails

- Ruby: `3.2.2`
- Rails: `7.1.3`
- Postgresql
- Sidekiq

## Getting Started

Follow these instructions to get the project up and running on your local machine.

### Prerequisites

Ensure you have the following installed:

- Ruby
- Rails
- Bundler
- Postgresql
- Sidekiq

### Installation

1. **Clone the repository**:
    ```sh
    git clone https://github.com/kstomar/test_result_app.git
    cd test_result_app
    ```

2. **Install dependencies**:
    ```sh
    bundle install
    ```

3. **Set up the database**:
    ```sh
    rails db:create
    rails db:migrate
    ```

4. **Start the Rails server**:
    ```sh
    rails server
    ```

5. **Start the sidekiq**:
    ```sh
    bundle exec sidekiq
    ```

6. **Run API**:

    You can test API on -  `http://localhost:3000`.

6. **Run Rspec**:
    ```sh
    bundle exec rspec spec
    ```

7. **Run cucumber**:
    ```sh
    bundle exec cucumber
    ```

## Usage

Postman collection - 
`https://documenter.getpostman.com/view/37206150/2sA3kXEfqq`
