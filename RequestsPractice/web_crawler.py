# -*- coding:utf-8 -*-

import requests, os, os.path, re

default_path = 'D:\\temp\\'

def get_file_name(img_url):
    return os.path.split(img_url)[1]

def save_image(img_url, file_path=default_path):
    fh = None
    try:
        print 'Downloading image %s' % img_url
        headers = {'User-Agent': 'Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/43.0.2357.130 Safari/537.36'}
        r = requests.get(img_url, headers = headers)
        if r.status_code == 200:
            img_content = r.content
            fh = open(os.path.join(file_path, get_file_name(img_url)), 'wb')
            fh.write(img_content)
        else:
            print 'Error code %d returned when accessing %s' %(r.status_code, img_url)
    except Exception, ex:
        print ex
    finally:
        if fh is not None:
            fh.close()

def get_movie_list(url):
    movie_items = []
    try:
        r = requests.get(url)
        if r.status_code != 200:
            print 'Oppos... Something bad happens, pls check your url: %s' % url
            return
        for movie_url in re.findall('https://movie.douban.com/subject/\d+/', r.content):
            if movie_url not in movie_items:
                movie_items.append(movie_url)
        return movie_items
    except Exception, ex:
        print ex

def dl_movie_posters(url):
    try:
        movie_posters_url = url + 'photos?type=R'
        print '\nRetriving URL to get movie posters: %s \n' % movie_posters_url
        r = requests.get(movie_posters_url)
        if r.status_code != 200:
            print 'Error in accessing the URL %s with status code %d' % (movie_posters_url, r.status_code)
            return
        # Create a new folder for movie posters
        posters_path = os.path.join(default_path, re.findall('\d+', url)[0])
        if not os.path.exists(posters_path):
            os.mkdir(posters_path)
        # Iterate all img tags
        for poster_url in re.findall('https://img3.doubanio.com/view/photo/thumb/.*\.jpg', r.content):
            # Save image to posters path
            save_image(poster_url.replace('thumb', 'photo'), posters_path)
    except Exception, ex:
        print ex

if __name__=='__main__':
    index = 0

    print 'Web Spider - Download poster of TOP 250 Movies'

    while index<=250:

        page_url = 'https://movie.douban.com/top250?start=%d&filter=' % index
        print 'Page URL: %s' % page_url
        for movie_url in get_movie_list(page_url):
            dl_movie_posters(movie_url)
            
        #Increase the index for the next 25 movies
        index+=25