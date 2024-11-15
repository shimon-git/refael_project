#!/usr/bin/bash

# Define the username
USERNAME="ansible"

# Create the new user
echo "Creating user '$USERNAME'..."
sudo adduser --gecos "" $USERNAME

# Add the user to the sudo group
echo "Adding '$USERNAME' to sudo group..."
sudo usermod -aG sudo $USERNAME

# Grant the user passwordless sudo privileges
echo "Granting passwordless sudo privileges to '$USERNAME'..."
echo "$USERNAME ALL=(ALL) NOPASSWD:ALL" | sudo tee /etc/sudoers.d/$USERNAME

# Set the correct permissions for the sudoers file
sudo chmod 0440 /etc/sudoers.d/$USERNAME