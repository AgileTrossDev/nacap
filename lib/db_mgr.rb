class DbMgr
  
  def initialize dbname, dbuser
    @db_name = dbname
    @db_user = dbuser
  end
  
  
  def check_and_insert_user user_data
    begin
      con = PG.connect :dbname => @db_name, :user => @db_user 
      con.prepare 'stm1', "SELECT EXISTS(select 1 from users where username=$1)"
      rs = con.exec_prepared 'stm1', [user_data["name"]]
        
      if rs.values == [["f"]] then
        con.prepare 'stm_insert', "INSERT INTO users(username) VALUES($1);"
        rs = con.exec_prepared 'stm_insert', [user_data["name"]]                   
      end

    rescue PG::Error => e
        puts e.message 
    ensure
        rs.clear if rs
        con.close if con
    end
    
  end
  
  
  def check_and_insert_song user_data
    return if user_data["songs"].nil?
    user_data["songs"].each do |song|
      begin
        con = PG.connect :dbname => @db_name, :user => @db_user 
        con.prepare 'stm1', "SELECT EXISTS(select 1 from songs where song_title=$1)"
        rs = con.exec_prepared 'stm1', [song]
          
        if rs.values == [["f"]] then
          con.prepare 'stm_insert', "INSERT INTO songs(song_title) VALUES($1);"
          rs = con.exec_prepared 'stm_insert', [song]                   
        end
  
      rescue PG::Error => e
          puts e.message 
      ensure
          rs.clear if rs
          con.close if con
      end
      
      check_and_make_song_like user_data["name"], song
    end
    
  end
  
  def check_and_insert_connections user_data
    puts "check_and_insert_connections: #{user_data}"
    return if user_data["connections"].nil?
    user_data["connections"].each do |friend|
      check_and_insert_user ({"name" => friend})
      check_and_make_connection user_data["name"], friend
      check_and_make_connection friend, user_data["name"]
    end
    
  end
  
  
  def query_user_id user_name
    begin
      con = PG.connect :dbname => @db_name, :user => @db_user 
      con.prepare 'stm1', "SELECT user_id FROM users WHERE username=$1"
      rs = con.exec_prepared 'stm1', [user_name]
      puts "USER NAME: #{user_name} #{rs[0]}"
      return rs[0]["user_id"]
    rescue PG::Error => e
          puts e.message 
    ensure
          rs.clear if rs
          con.close if con
    end
  end
  
  
  def query_user_name user_id
    begin
      con = PG.connect :dbname => @db_name, :user => @db_user 
      con.prepare 'stm1', "SELECT username FROM users WHERE user_id=$1"
      rs = con.exec_prepared 'stm1', [user_id]
      puts "USER NAME: #{user_id} #{rs[0]}"
      return rs[0]["username"]
    rescue PG::Error => e
          puts e.message 
    ensure
          rs.clear if rs
          con.close if con
    end
  end
  
  
  def query_song_id song
    begin 
      con = PG.connect :dbname => @db_name, :user => @db_user 
      con.prepare 'stm1', "SELECT song_id FROM songs WHERE song_title=$1"
      rs = con.exec_prepared 'stm1', [song]
      return rs[0]["song_id"]
    rescue PG::Error => e
      puts e.message 
    ensure
      rs.clear if rs
      con.close if con
    end
  end
  
  def query_song_title song_id
    begin 
      con = PG.connect :dbname => @db_name, :user => @db_user 
      con.prepare 'stm1', "SELECT song_title FROM songs WHERE song_id=$1"
      rs = con.exec_prepared 'stm1', [song_id]
      return rs[0]["song_title"]
    rescue PG::Error => e
      puts e.message 
    ensure
      rs.clear if rs
      con.close if con
    end
  end 
  
  
  def check_and_make_connection user_1, user_2
    begin
        id_1 = query_user_id user_1
        id_2 = query_user_id user_2
        
        puts "Trying to connect #{id_1} and #{id_2}"
        con = PG.connect :dbname => @db_name, :user => @db_user 
        con.prepare 'stm1', "SELECT EXISTS(select 1 FROM user_connections WHERE user_id_1=$1 AND user_id_2=$2)"
        rs = con.exec_prepared 'stm1', [id_1,id_2]
          
        if rs.values == [["f"]] then
          con.prepare 'stm_insert', "INSERT INTO user_connections(user_id_1,user_id_2) VALUES($1,$2);"
          rs = con.exec_prepared 'stm_insert', [id_1,id_2]                   
        end
  
    rescue PG::Error => e
          puts e.message 
    ensure
          rs.clear if rs
          con.close if con
    end
    
  end
  
  def check_and_make_song_like user_name, song
    
    user_id = query_user_id user_name
    song_id = query_song_id song
    
    begin
        con = PG.connect :dbname => @db_name, :user => @db_user 
        con.prepare 'stm1', "SELECT EXISTS(select 1 FROM song_likes WHERE user_id=$1 AND song_id=$2)"
        rs = con.exec_prepared 'stm1', [user_id,song_id]
          
        if rs.values == [["f"]] then
          con.prepare 'stm_insert', "INSERT INTO song_likes(user_id,song_id) VALUES($1,$2);"
          rs = con.exec_prepared 'stm_insert', [user_id,song_id]                   
        end
  
    rescue PG::Error => e
          puts e.message 
    ensure
          rs.clear if rs
          con.close if con
    end
    
  end
  
  # Inserts a complete set of User data into the datbase
  def insert_if_does_not_exist user_data
    check_and_insert_user user_data
    check_and_insert_song user_data
    check_and_insert_connections user_data
  end
  
  def query_for_user_connections user_name
    puts "Query for user connections..."
    begin
      con = PG.connect :dbname => @db_name, :user => @db_user 
      
      con.prepare 'stm1', "SELECT * FROM users WHERE username=$1"
      rs = con.exec_prepared 'stm1', [user_name]
      
      puts "USER NAME: #{user_name} #{rs[0]}" 
      user_id = rs[0]["user_id"]
      
      con.prepare 'stm2', "SELECT * FROM user_connections WHERE user_id_1=$1"
      rs = con.exec_prepared 'stm2', [user_id]
      
      results = []
      rs.each do |s|
         puts "User Connections #{user_name} #{s} "
         results.push query_user_name s["user_id_2"]
      end
     
      
      
      return results
    
    rescue PG::Error => e
          puts e.message 
    ensure
          rs.clear if rs
          con.close if con
    end
    
    
    
  end
  
  def query_for_user_song_likes user_name
    puts "Query for songs likes..."
    begin
      con = PG.connect :dbname => @db_name, :user => @db_user 
      
      con.prepare 'stm1', "SELECT * FROM users WHERE username=$1"
      rs = con.exec_prepared 'stm1', [user_name]
      
      puts "USER NAME: #{user_name} #{rs[0]}" 
      user_id = rs[0]["user_id"]
      
      con.prepare 'stm2', "SELECT * FROM song_likes WHERE user_id=$1"
      rs = con.exec_prepared 'stm2', [user_id]
      
      results = []
      rs.each do |s|
         puts "Song Likes #{user_name} #{s} "
         results.push query_song_title s["song_id"]
      end
     
      
      
      return results
    
    rescue PG::Error => e
          puts e.message 
    ensure
          rs.clear if rs
          con.close if con
    end
    
  end
  
  
  def query_for_user_data user_name
    begin
      con = PG.connect :dbname => @db_name, :user => @db_user 
      con.prepare 'stm1', "SELECT user_id, username FROM users WHERE username=$1"
      
      rs = con.exec_prepared 'stm1', [user_name]
      puts "USER NAME: #{user_name} #{rs[0]}"
      
      results = {}
      results["name"] = rs[0]["username"]
      results["id"] = rs[0]["user_id"]
      
      return results
    
    rescue PG::Error => e
      puts e.message 
    ensure
         rs.clear if rs
       con.close if con
    end
    
  end
  
  # Returns a hash that contains all user details, including connections and song likes
  def query_for_all_user_data user_name
    results = query_for_user_data user_name
    results["connections"] = query_for_user_connections user_name
    results["songs"]=  query_for_user_song_likes user_name
    return results
  end
  
end
