classdef HtmlPage
    %HTMLPAGE Creates html page
    %   HtmlPage(PATH, IMGFMT, OUTNAME) Creates an html page from dataset
    %   in PATH, with image format IMGFMT and output filename OUTNAME.
    %
	%   PATH     <char> 	: folder to dataset             required
    %   IMGFMT   <char> 	: format of images in dataset   ['png']
    %   OUTNAME  <char>     : output html filename          ['out']
    %
    %   Example:
    %       HtmlPage('data','jpg','output')
    % 
    %   Alex Bagur, 2019
    
    properties
        path
        imgfmt
        outname
        code = ''
    end
    
    methods
        function obj = HtmlPage(path, imgfmt, outname)
            %HTMLPAGE Construct an instance of this class
            arguments
                path
                imgfmt  = 'png'
                outname = 'out'
            end
            
            % Set properties
            obj.path    = path;
            obj.imgfmt  = imgfmt;
            obj.outname = outname;
            
            % Html header
            obj = obj.insertLine('<!DOCTYPE html>');
            obj = obj.insertLine('<html>');
            obj = obj.insertLine('<body>');
            
            % Get list of data and create html code for it
            obj = obj.insertDirectoryList();
            
            % Write html to file and open
            obj.open();
        end
        
        function obj = insertImage(obj,imgPath)
            %INSERTIMAGE Appends an image to the html file
            obj = obj.insertLine(['<img src="' imgPath '" alt="image"' ... 
                'height="200">']);
        end
        
        function obj = insertImageList(obj,imgSearchPath)
            %INSERTIMAGELIST Gets all image files from a folder and inserts
            %them to html
            imgList = dir(imgSearchPath);
            if isempty(imgList)
                warning('No images in this directory')
                return
            end
            obj = obj.insertLine('<h3>Images</h3>');
            for ii=1:numel(imgList)
                fname = [imgList(ii).folder filesep imgList(ii).name];
                disp(['|-- ' num2str(ii) ' of ' num2str(numel(imgList)) ': ' imgList(ii).name])
                obj = obj.insertImage(fname);
            end
        end
        
        function obj = insertDirectoryList(obj)
            %INSERTDIRECTORYLIST Gets all directories in searchPath and inserts
            %images from study in html
            dirList = dir(obj.path);
            if isempty(dirList)
                warning('No directories underneath')
                return
            end
            obj = obj.insertLine('<h2>Summary Page</h2>');
            for ii=1:numel(dirList)
                if isequal(dirList(ii).name,'.') || ...
                        isequal(dirList(ii).name,'..')
                    continue
                end
                dirname = [dirList(ii).folder filesep dirList(ii).name];
                disp([dirList(ii).name ' ...'])
                obj = obj.insertLine(['<h3>Directory ' dirList(ii).name '</h3>']);
                obj = obj.insertImageList([dirname filesep '*.' obj.imgfmt]);
            end
        end
        
        function obj = insertLine(obj,str)
            %INSERTLINE Inserts a line of code to the html source code
            obj.code = append(obj.code,str,'\n');
        end
        
        function open(obj)
            %OPEN creates the html file and opens in web browser
            obj = obj.insertLine('</body>');
            obj = obj.insertLine('</html>');
            
            htmlname = [obj.outname '.html'];
            fileID=fopen(htmlname,'w+'); 
            fprintf(fileID, sprintf(obj.code));
            fclose(fileID);
            web(htmlname, '-browser');
        end
    end
end

