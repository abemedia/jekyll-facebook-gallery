# Jekyll Facebook Gallery Plugin
Jekyll Plugin which displays photo albums from Facebook pages or profiles.

## Installation
Copy the `facebook-gallery.rb` file into your `plugins` directory and add the configuration values below to your `_config.yml`, exchanging test for the username of the page or profile you'd like to grab the pictures from.

## Example Configuration:
    facebook_gallery:
        username: test
        exclude:
            - 'Timeline Photos'
            - 'Cover Photos'
            - 'Profile Pictures'
