class LinkController < ApplicationController
   
   # create page
   def new
    render "new"
   end
   
    # create action
    def create
        l = Link.new
        l.url = params[:url]
        l.title = params[:title]
        l.description = params[:description]
        l.user_id = session[:user_id]
        if l.save
            tags = params[:tags].split(",")
            puts(tags)
            tags.each {
                |tag|
                curTag = Tag.find_by(name: tag)
                tl = Taglink.new
                if curTag == nil
                    t = Tag.new
                    t.name = tag
                    t.user_id = session[:user_id]
                    t.save
                    
                    tl.tag_id = t.id
                else
                    tl.tag_id = curTag.id
                end
                tl.link_id = l.id
                tl.save
            }
        end
        
        redirect_to "/user/view/#{session[:user_id]}"
    end
    
    # tag index page
    def tags
       @tags = Tag.where(user_id: session[:user_id])
       render "index"
    end
    
    # edit index page
    def edit_index
        @links = User.find_by(id: session[:user_id]).links
        render "edit_index"
    end
   
    # edit page
    def edit
       @link = Link.find_by(id: params[:id])
       render "edit"
    end
    
    # edit action
    def update
        l = Link.find_by(id: params[:id])
        l.url = params[:url]
        l.title = params[:title]
        l.description = params[:description]
        if l.save
           redirect_to "/link/edit_index"
        else
            @error_message = "There was an error"
            @link = l
            render "edit"
        end
    end
    
    # add tag action
    def add_tag
        tags = params[:tags].split(",")
        puts(tags)
        ret = [];
        tags.each {
            |tag|
            curTag = Tag.find_by(name: tag)
            tl = Taglink.new
            if curTag == nil
                t = Tag.new
                t.name = tag
                t.user_id = session[:user_id]
                t.save
                
                tl.tag_id = t.id
            else
                tl.tag_id = curTag.id
            end
            tl.link_id = Integer(params[:id])
            if Taglink.find_by(tag_id: tl.tag_id, link_id: tl.link_id) == nil
                tl.save
                ret.push(Tag.find_by(id: tl.tag_id))
            end
        } 
        render :json => {"data" => ret}
    end
    
    # remove tag action
    def remove_tag
       puts(params[:tag_name]) 
       tag = Tag.find_by(name: params[:tag_name])
       tl = Taglink.find_by(tag_id: tag.id, link_id: Integer(params[:id]))
       tl.destroy
       render :json => {"data" => "success"} 
    end
    
    # return tag suggestions
    def tag_suggestions
        render :json => {"data" => Tag.where("name LIKE ?", "#{params[:partial_name]}%")}
    end

    # destroy action
    def destroy
        l = Link.find_by(id: params[:id])
        l.tags.each do |t|
           tl = Taglink.find_by(link_id: l.id, tag_id: t.id)
           tl.destroy
        end
        l.destroy
        redirect_to "/user/view/#{session[:user_id]}"
    end
end