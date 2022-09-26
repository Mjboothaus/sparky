from zipfile import ZipFile
import gzip

def zip_to_gzip(zip):
    zfile = ZipFile(zip)
    filename = zfile.namelist()[0]
    data = zfile.read(filename)
    with open(f'/tmp/{str(filename)}', 'wb') as f:
        f.write(data)

    with gzip.open(f'/tmp/{filename}.gz', 'wb') as gzip_file:
        gzip_file.write(data)
        