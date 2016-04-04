import os, glob, pickle, shutil

movies_dir = glob.glob('../../Data/movies/*')

cast_file_name = 'cast_info.dat'

for movie_dir in movies_dir:
    with open(movie_dir+'/'+cast_file_name) as f:
        d = pickle.load(f)

    folder_path = movie_dir + '/actors_facetrack'
    try:
        if os.path.exists(folder_path):
            shutil.rmtree(folder_path)
        os.makedirs(folder_path)
    except Exception as e:
        print('Error in making the movie folder.')
        print(e)

    for actor in d:
        new_folder_path = folder_path + '/' + actor.replace(' ', '_')
        os.makedirs(new_folder_path)

