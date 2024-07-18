import tweepy
import os
import argparse

# Function to get command line arguments
def get_args():
    parser = argparse.ArgumentParser(description='Tweet an image with text')
    parser.add_argument('tweet_path', type=str, help='The path of the tweet')
    parser.add_argument('image_path', type=str, help='The path to the image')
    return parser.parse_args()

def main():
    args = get_args()
    
    # Your Twitter API credentials
    API_KEY = os.getenv('API_KEY')
    API_SECRET_KEY = os.getenv('API_SECRET_KEY')
    ACCESS_TOKEN = os.getenv('ACCESS_TOKEN')
    ACCESS_TOKEN_SECRET = os.getenv('ACCESS_TOKEN_SECRET')
    BEARER_TOKEN = os.getenv('BEARER_TOKEN')

    # Authenticate to Twitter
    client = tweepy.Client(
        consumer_key=API_KEY, consumer_secret=API_SECRET_KEY,
        access_token=ACCESS_TOKEN, access_token_secret=ACCESS_TOKEN_SECRET,
        bearer_token=BEARER_TOKEN
    )

    auth = tweepy.OAuth1UserHandler(API_KEY, API_SECRET_KEY,
                                    ACCESS_TOKEN, ACCESS_TOKEN_SECRET)
    api = tweepy.API(auth)

    # Use the command line arguments
    # Path to the text file containing the tweet message
    tweet_message_path = args.tweet_path

    # Read the tweet message from the text file
    with open(tweet_message_path, 'r') as file:
      tweet = file.read().strip()

    image_path = args.image_path

    # Upload the image
    media = api.media_upload(image_path)

    # Create the tweet
    client.create_tweet(text=tweet, media_ids=[media.media_id])

if __name__ == '__main__':
    main()
