# -*- coding:utf-8 -*-

import requests, os,os.path, sqlite3, re
from random import randint
from bs4 import BeautifulSoup

class BookInfo:
    def __init__(self, title, author, pub_year, num_of_reviews, url):
        self.title = title
        self.author = author
        self.pub_year = str(pub_year)
        self.num_of_reviews = int(num_of_reviews)
        self.url = url

DB_FILE_PATH = 'best_sellers_in_books.db'

POSSIBLE_AGENTS = ['Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.11 (KHTML, like Gecko) Chrome/23.0.1271.64 Safari/537.11',
                  'Mozilla/5.0 (compatible; MSIE 9.0; Windows NT 6.1; Win64; x64; Trident/5.0)',
                  'Mozilla/5.0 (X11; U; Linux x86_64; zh-CN; rv:1.9.2.10) Gecko/20100922 Ubuntu/10.10 (maverick) Firefox/3.6.10',
                  'Mozilla/5.0 (compatible; MSIE 9.0; Windows NT 6.1; Win64; x64; Trident/5.0)',
                  'Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:2.0b13pre) Gecko/20110307 Firefox/4.0b13pre']

def get_books_in_current_page(year, index):
    try:
        URL = 'https://www.amazon.com/gp/bestsellers/%d/books/ref=zg_bsar_cal_ye#%d' % (year, index)
        print 'Prepare to download best sellers of %d in books on page %d: %s' %(year, index, URL)
        ua = POSSIBLE_AGENTS[randint(0,4)]
        print 'Create request with user-agent: %s' % ua
        headers = {'User-Agent': ua}
        r = requests.get(URL, headers = headers)
        if r.status_code != 200:
            print 'Error in accessing the URL %s with status code %d' % (URL, r.status_code)
            return None
        html_soup = BeautifulSoup(r.content, 'html.parser')
        div_tag_books = html_soup.find_all(name='div', attrs={'class': 'zg_itemWrapper'})
        #If find best sells of books in current page
        if div_tag_books==None or len(div_tag_books)==0:
            return None
        books_lst = []
        for div_tag_book_item in div_tag_books:
            # Locate the <div> whose class value is 'zg_byline', to finally find the author name
            div_tag_author = div_tag_book_item.find(name='div', attrs={'class', 'zg_byline'})
            if div_tag_author is not None:
                author = div_tag_author.string.replace('\n','').replace('by ','')
            else:
                author = 'N/A'
            # Locate the <a> tag in div where the class value is 'zg_title'
            div_tag_title = div_tag_book_item.find(name='div', attrs={'class', 'zg_title'})
            if div_tag_title is not None:
                title = div_tag_title.string.strip()
                url = div_tag_title.find('a').get('href').strip().replace('\n', '')
            else:
                title = 'N/A'
            # Locate the <span> tag to get the total number of reviews
            span_tag_reviews = div_tag_book_item.find(name='span', attrs={'class', 'a-size-small'}).find('a')
            if span_tag_reviews is not None:
                num_of_reviews = span_tag_reviews.string.strip().replace(',','')
            else:
                num_of_reviews = ''
            #print 'Title:%s    Author:%s      Reviews: %s       URL: %s' % ( title, author, num_of_reviews, url)
            books_lst.append(BookInfo(title, author, year, num_of_reviews, url))
        #Return the books back
        return books_lst
    except Exception, ex:
        print ex
        
def create_database():
    conn = None
    try:
        if os.path.exists(DB_FILE_PATH):
            os.remove(DB_FILE_PATH)
        conn = sqlite3.connect(DB_FILE_PATH)
        cu = conn.cursor()
        cu.execute('''CREATE TABLE BOOKS(
                      ID Integer,
                      TITLE VARCHAR(250),
                      AUTHOR VARCHAR(100),
                      PUB_YEAR VARCHAR(5),
                      URL VARCHAR(250),
                      NUM_OF_REVIEWS Integer,
                      PRIMARY KEY(ID)
                      )''')
    except Exception, ex:
        print ex
    finally:
        if conn is not None:
            conn.close()

def write_books_info_to_DB(books_lst):
    conn = None
    try:
        if books_lst is None:
            print 'Empty books list passed'
        conn = sqlite3.connect(DB_FILE_PATH)
        cx = conn.cursor()
        sql_template = '''INSERT INTO BOOKS(TITLE, AUTHOR, PUB_YEAR, URL, NUM_OF_REVIEWS)
                          VALUES("%s", "%s", "%s", "%s", %d)'''
        for book in books_lst:
            sql = sql_template % (book.title, book.author, book.pub_year, book.url, book.num_of_reviews)
            cx.execute(sql)
    except Exception, ex:
        print ex
    finally:
        if conn is not None:
            conn.commit()
            conn.close()
            print '%d book records have been written.' % len(books_lst) 

def main():
    # Clear original result by creating a new sqlite file
    create_database()
    # Iterate all possible years to get best sellers of TOP 100 books
    for year in range(1995,2017):
        for index in range(1,6):
            books_lst = get_books_in_current_page(year, index)
            write_books_info_to_DB(books_lst)
    # Done.
    print 'Done. '
    
if __name__=='__main__':
    main()