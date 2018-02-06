# Install first the dependencies...
echo "Installing dependencies"
shards

# Build the executable in release mode...
echo "Building the executable"
crystal build src/sharn.cr --release --no-debug

# Move executable to /usr/local/bin
echo "Moving the executable to /usr/local/bin"
sudo mv ./sharn /usr/local/bin
echo "Done"
