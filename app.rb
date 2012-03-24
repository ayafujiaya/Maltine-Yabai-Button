require 'rubygems'
require 'sinatra'
require 'dm-core'
require 'dm-migrations'



DataMapper.setup(:default, ENV['DATABASE_URL'] || 'sqlite3:db.sqlite3')

class Post #データベースを操作するクラス

    include DataMapper::Resource

  def migrate
    DataMapper.auto_migrate!
  end

  property :id, Serial
  property :number, Integer
  property :create_at, DateTime
  property :per_minute, Integer
  property :per_hour, Integer
  auto_upgrade!
end

class PerMath

	include DataMapper::Resource
  
  def init
	@min = Time.now
	$per_minute = 0
	$per_hour = 0
	
  end

  def per_update
	Post.all.map{ |r| 
		if @min.year == r.create_at.year &&
			@min.month == r.create_at.month &&
			@min.day == r.create_at.day &&
			@min.hour == r.create_at.hour &&
			@min.min == r.create_at.min then
			$per_minute += 1
		end
		}
	end
	
	def hour_update
	Post.all.map{ |r| 
		if @min.year == r.create_at.year &&
			@min.month == r.create_at.month &&
			@min.day == r.create_at.day &&
			@min.hour == r.create_at.hour then
			$per_hour += 1
		end
		}
	end
	
  def getPer_minute
	hoge = Post.all.size
	if hoge != 0 then
		"#{Post.all[Post.all.size - 1].per_minute}" 
	else
		"0"
	end
  end
  
    def getPer_hour
	hoge = Post.all.size
	if hoge != 0 then
		"#{Post.all[Post.all.size - 1].per_hour}" 
	else
		"0"
	end
  end

  def jsGen
	
  end
end

$hoge = PerMath.new()


get '/' do
  erb :index
  
end

post '/' do
$hoge.init
$hoge.per_update
$hoge.hour_update

  post = Post.create(
    :number => 0,
    :create_at => Time.now,
	:per_minute => $per_minute.to_i,
	:per_hour => $per_hour.to_i
)
end

get '/reload' do
	redirect '/'
end

get '/reset' do
	Post.auto_migrate!
  redirect '/'
end

get '/map' do
  Post.all.map{ |r| "#{r.id}, #{r.number},日時#{r.create_at.year}<br/>"}
end

