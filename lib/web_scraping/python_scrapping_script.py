# from selenium import webdriver
# from bs4 import BeautifulSoup

# # URL of the webpage you want to scrape
# def scrapingdata (url,class_name):

# # Use Selenium to open a browser window and navigate to the URL
#  driver = webdriver.Chrome()  # You need to have ChromeDriver installed and in your PATH
#  driver.get(url)

# # Wait for the page to fully load (you may need to adjust the waiting time)
#  driver.implicitly_wait(10)

# # Get the page source after it's fully loaded
#  html = driver.page_source

# # Close the browser window
#  driver.quit()

# # Parse the HTML content of the webpage using BeautifulSoup
#  soup = BeautifulSoup(html, 'html.parser')

# # Dictionary to store data for each class
#  class_data_map = {}

# # Define the class names you want to extract
#  class_names = ['name', 'lecture', 'workshop']  # Replace these with actual class names

# # Iterate over each class name and find elements with that class
#  for class_name in class_names:
#     elements = soup.find_all(class_=class_name)
#     class_data = []
#     for element in elements:
#         # Extract text content or other data from the element and append it to the class_data list
#         class_data.append(element.text.strip())  # Adjust this according to your requirements
#     # Store the class data list in the dictionary with the class name as the key
#     class_data_map[class_name] = class_data

# # Print or use the class data map as needed
#  return(class_data_map)
# # # Example usage:
# # url = 'https://transcendent-zabaione-053e2b.netlify.app/student/1'
# # class_names = ['name', 'lecture', 'workshop']  # Replace these with actual class names
# # data = scraping_data(url, class_names)
# # print(data)