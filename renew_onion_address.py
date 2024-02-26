from stem import Signal
from stem.control import Controller

def read_password_from_file(file_path="tor_controller_pwd.key"):
	try:
		with open(file_path, 'r') as file:
			return file.read().strip()
	except IOError as e:
		print(f"Unable to read the Tor control password from {file_path}: {e}")
		exit(1)

def renew_onion_service(controller):
	# Create a new ephemeral onion service
	response = controller.create_ephemeral_hidden_service({80: 80}, await_publication=True)
	print("New onion service address:", response.service_id + ".onion")
	return response.service_id

def main():
	control_password = read_password_from_file()

	with Controller.from_port(port=9051) as controller:
		controller.authenticate(password=control_password)

		service_id = renew_onion_service(controller)
		print("Press any key to remove the onion service and exit.")
		input()  # Wait for user input to proceed

		# Remove the ephemeral onion service
		controller.remove_ephemeral_hidden_service(service_id)
		print("Removed onion service:", service_id)

		# Send NEWNYM signal to use a new circuit
		controller.signal(Signal.NEWNYM)

if __name__ == "__main__":
	main()
