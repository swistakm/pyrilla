# -*- coding: utf-8 -*-
import os

import dropbox
import dropbox.files

dropbox_token = os.environ.get('DROPBOX_TOKEN')

dbx = dropbox.Dropbox(dropbox_token)


for root, dirs, files in os.walk('dist'):
    for filename in files:
        local_path = os.path.join(root, filename)
        relative_path = os.path.relpath(local_path, 'dist')
        dropbox_path = "/" + relative_path

        with open(local_path, 'rb') as f:
            print("uploading %s" % local_path)
            dbx.files_upload(
                f, dropbox_path,
                dropbox.files.WriteMode('overwrite')
            )
