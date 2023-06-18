# Use an official Python runtime as the base image
FROM python:3.9

# Set the working directory in the container
WORKDIR /app/src

# Copy the poetry files to the working directory
COPY src/pyproject.toml src/poetry.lock /app/

# Install Poetry
RUN pip install poetry

# Copy the application code to the working directory
COPY . /app

# Create a virtual environment and activate it
RUN python -m venv venv
ENV PATH="/app/venv/bin:$PATH"

# Install project dependencies within the virtual environment
RUN poetry install --no-interaction --no-ansi

# Expose any necessary ports
EXPOSE 8000

# Define the command to run the application
CMD ["poetry", "run", "python", "manage.py", "runserver"]
