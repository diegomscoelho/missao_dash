from instagrapi import Client
import os
import argparse

# Function to get command line arguments
def get_args():
    parser = argparse.ArgumentParser(description='Post an Instagram image with text')
    parser.add_argument('--path', type=str, help='The path of Instagram image')
    parser.add_argument('--paths', type=str, help='The path of Instagram images')
    parser.add_argument('--msg', type=str, help='The path of the image')
    return parser.parse_args()

def main():
    args = get_args()
    
    # Your Twitter API credentials
    INSTA_LOGIN = os.getenv('INSTA_LOGIN')
    INSTA_PASS = os.getenv('INSTA_PASS')

    cl = Client()
    cl.login(INSTA_LOGIN, INSTA_PASS)

    # Path to the text file containing the tweet message
    msg_path = args.msg

    # Read the tweet message from the text file
    with open(msg_path, 'r') as file:
      msg = file.read().strip()

    if args.path:
        # Single image upload
        cl.photo_upload(path=args.path.strip(), caption=msg)
    elif args.paths:
        # Multiple images upload
        image_paths = args.paths.strip().split(',')
        cl.album_upload(path=image_paths, caption=msg)
    else:
        print("Error: You must provide either a path or paths argument.")


if __name__ == "__main__":
    main()
