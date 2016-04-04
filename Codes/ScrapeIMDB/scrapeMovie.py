import requests
from bs4 import BeautifulSoup
import os, shutil, json

import warnings
warnings.filterwarnings("ignore")

urls = ['http://www.imdb.com/title/tt2267998/',
        'http://www.imdb.com/title/tt0314331/?ref_=nv_sr_1']

for url in urls:
    r = requests.get(url)

    soup = BeautifulSoup(r.content)

    title = str(soup.title.text)
    print(title)

    # check if the movie folder exists if not make a new folder
    folder_path = '../../Data/movies/' + title[:-7].replace(' ', '_')
    try:
        if os.path.exists(folder_path):
            shutil.rmtree(folder_path)
        os.makedirs(folder_path)
    except Exception as e:
        print('Error in making the movie folder.')
        print(e)

    with open(folder_path+'/actor_info.txt', 'w+') as f:
        # get the cast list section from html
        tmp = soup.find('table', {'class':'cast_list'})

        characters = tmp.findAll('tr', {'class':'odd'})
        characters = characters + tmp.findAll('tr', {'class':'even'})

        actors = {}

        for char in characters:
            try:
                name = str(char.find('span').text)

                try:
                    actors[name] = {}
                    actors[name]['actor_name'] = name
                    actors[name]['actor_url'] = char.find('td', {'itemprop':'actor'}).find('a').get('href')
                    actors[name]['actor_id'] = actors[name]['actor_url'][6:\
                        actors[name]['actor_url'].rfind('/')]
                    character_block = char.find('td', {'class':'character'}).find('a')
                    actors[name]['character_name'] = str(character_block.text)
                    actors[name]['character_url'] = character_block.get('href')
                    actors[name]['character_id'] = actors[name]['character_url'][11: \
                        actors[name]['character_url'].rfind('/')]
                except Exception:
                    pass

                if name in actors:
                    for item in actors[name]:
                        f.write(item + ': ' + actors[name][item] + '\n')
                    f.write('\n')

            except Exception:
                pass

            with open(folder_path+'/cast_info.dat', 'w+') as f2:
                json.dump(actors, f2)
            #print(' ')

