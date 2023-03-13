class Graph
  attr_accessor :vertices, :oriented, :name, :ves
  INF = 1.0/0.0

  #Конструктор по умолчанию
  def initialize(name, orient = false, ves = false, file_path = nil)
    @vertices = []
    @oriented = orient
    @ves = ves
    @name = name
    if file_path != nil
      file_path = "GraphTest4.txt"
      if File.exist?(file_path)
        f = File.new(file_path, "r:UTF-8")
        lines = f.readlines
        f.close
        lines.each.with_index do |l, index|
          if index > 2
            add_vertex(l.split(" ")[0])
          end
        end
        lines.each do |l|
          l.scan(/\[(.*?)\]/).each do |letter|
            letter = letter.join("").tr('[', '').tr(']', '').tr(',', ' ')
            letter = letter.split(' ').to_a
            weight = nil
            if ves
              weight = letter[1]
              add_edge(l[0], letter[0], weight)
            else
              add_edge(l[0], letter[0])
            end
            #puts "from: #{l[0]} to #{letter[0]} weight #{letter[1]} \n"
          end
        end
      end
    end
  end

  #Метод добавления вершины
  def add_vertex(name)
    flag = true
    vertices.each do |gege|
      if gege[:name] == name
        flag = false
        break;
      end
    end
    if flag
      @vertices << {
        name: name,
        neighbors: []
      }
    else
      puts "Вершина с таким именем уже существует"
    end
  end

  #Метод добавления ребра
  def add_edge(first_vertex, second_vertex, weight = nil)
    f1 = false
    f2 = false
    vertices.each do |gege|
      if gege[:name] == first_vertex.to_s
        f1 = true
      end
      if gege[:name] == second_vertex.to_s
        f2 = true
      end
    end
    puts f1, f2
    if f1 && f2 
      if oriented
        vertices.select do |e|
          if e[:name] == first_vertex.to_s
            puts 'added'
            e[:neighbors] << { neighbor: second_vertex, weight: weight }
            break
          end
        end
      else
        vertices.select do |e|
          if e[:name].to_i == first_vertex.to_s
            e[:neighbors] << { neighbor: second_vertex, weight: weight }
          end
          if e[:name].to_i == second_vertex.to_s
            e[:neighbors] << { neighbor: first_vertex, weight: weight }
          end
        end
      end
    else
      puts "Одна из вершин не существует"
    end
  end

  #Метод удаления ребра
  def delete_edge(first_vertex, second_vertex)
    f1 = false
    f2 = false
    vertices.each do |gege|
      if gege[:name] == first_vertex.to_s
        f1 = true
      end
      if gege[:name] == second_vertex.to_s
        f2 = true
      end
    end
    if f1 && f2
      if oriented
        vertices.select do |e|
          if e[:name] == first_vertex.to_s
              if !(e[:neighbors].reject! {|r| r[:neighbor] == second_vertex.to_s}).nil?
                return puts "<-------------Дуга успешно удалена"
              else
                return puts "<-------------Дуга не найдена"
              end
          end
        end
      else
        f1 = false
        f2 = false
        vertices.select do |e|
          if e[:name] == first_vertex
              if !(e[:neighbors].reject! {|r| r[:neighbor] == second_vertex}).nil?
                f1 = true
              end
          end
          if e[:name] == second_vertex
            if !(e[:neighbors].reject! {|r| r[:neighbor] == first_vertex}).nil?
              f2 = true
            end
          end
        end
        if f1 && f2
          return puts "<-------------Дуга успешно удалена"
        else
          return puts "<-------------Дуга не найдена"
        end
      end
    else
      return puts "<-------------Одна из вершин отсутствует в графе"
    end
  end

  #Метод удаления вершины
  def delete_vertex(vertex)
    vertices.each do |v|
      delete_edge(v[:name], vertex)
    end
    vertices.delete_if {|e| e[:name] == vertex}
  end

  #Вывод списка смежности
  def vivod
    vertices.each do |v|
      print "Вершина #{v[:name]} => Ребра {" 
      v[:neighbors].each do |n|
        print " №:#{n[:neighbor]}  Weight:#{n[:weight]} ;"
      end
      puts " }"
    end
  end
  #какие-то номера с курса по графам
  def a1n19
    #Определить, существует ли вершина, в которую есть дуга как из вершины u, так и из вершины v. Вывести такую вершину.
    print "Введите u и v: "
    v1 = gets.to_i
    v2 = gets.to_i
    u1 = []
    u2 = []
    vertices.each do |e|
      if e[:name].to_i == v1
        e[:neighbors].each do |n|
          u1 << n[:neighbor]
        end
      end
      if e[:name].to_i == v2
        e[:neighbors].each do |n|
          u2 << n[:neighbor]
        end
      end
    end
    if !((u1 & u2).nil?)
      print "Вершина нашлась: "
      puts (u1 & u2)[0]
    else
      puts "Такой вершины нет"
    end
  end

  def a1n20
    print "Введите вершину: "
    v1 = gets.to_i
    u1 = []
    u2 = []
    vertices.each do |e|
      if e[:name].to_i == v1
        e[:neighbors].each do |n|
          u1 << n[:neighbor].to_i
        end
      end
      u2 << e[:name].to_i
    end
    print u2 - u1
    puts
  end

  def b1n12
    if oriented
      vertices.each do |e|
        counter = 0
        vertices.each do |v|
          if e[:name] == v[:name]
            next
          else
            v[:neighbors].each do |n|
              if n[:neighbor] == e[:name]
                counter += 1
              end
            end
          end
        end
        if counter < 1
          if e[:neighbors].count <= 1
            delete_vertex(e[:name])
          end
        end
      end
    else
      if e[:neighbors].count <= 1
        delete_vertex(e[:name])
      end
    end
  end
#вспомогательный метод
  def FindVertexbyIndex(name)
    vertices.each_with_index do |v, i|
      if name == v[:name].to_i
        return v
        break
      end
    end
  end
  def get_index_by_name(_vertex_name)
    vertices.each_with_index do |vertex, index|
      if vertex[:name] == _vertex_name
        return index
      end
    end
  end
  def index_of(_vertex_name)
    return vertices.index { |v| v[:name] == _vertex_name }
  end
  def dva28(_start_index)
    bfs_result = []
    dist = 0
    dist_array = []
    vertex_array = []
    visited_vertices = Array.new(vertices.count, false)
    v_queue = []
    v_queue.unshift(vertices[_start_index])
    visited_vertices[_start_index] = true
    until v_queue.empty?
      dist +=1
      node = v_queue.shift
      bfs_result << node[:name]
      node[:neighbors].each do |nb|

        if !vertex_array.include?(nb[:neighbor])
          vertex_array << nb[:neighbor]
          dist_array << dist
        end
        vind = get_index_by_name(nb[:neighbor])
        next if visited_vertices[vind]
        v_queue.unshift(vertices[vind])
        visited_vertices[vind] = true
      end
    end
    return dist_array, vertex_array
  end

  def dva36()
    radius = []
    puts 
    for i in 0..vertices.count-1
     x,y = dva28(i)
     radius << x.max
     puts "Экцентариситет вершины #{i} это #{x.max}"
    end
    return radius
  end

#вспомогательный метод
  def array_contains_str(_arr, _ind, _str)
    _arr.each do |a|
      if a[_ind] == _str || a[_ind] == _str.reverse
        return true
      end
    end
    return false
  end
  
  def make_edges_array
    array = []
    vertices.each do |v|
      v[:neighbors].each do |n|
        str = "#{v[:name]}" + n[:neighbor]
        if !array_contains_str(array, 0, str)
          array << [str, n[:weight].to_i]
        end
      end
    end
    return array.sort_by {|a| a[1]}
  end
  #алгоритм Крускала
  def kruskal
    ma = make_edges_array
    parent = Array.new(vertices.length-1)
    parent[0] = -1
    for k in 0..ma.count-1
      currentEdge = ma[k]
      vertexFrom = currentEdge[0][0].to_i
      vertexTo = currentEdge[0][1].to_i
      #isCycleTriggered = parent[vertexTo] == parent[vertexFrom]
      if vertexTo != 0 && parent[vertexTo].nil?
          # add to mst
          parent[vertexTo] = vertexFrom
      end
    end
    return parent
  end

  #Алгоритм Дейкстры
  def dijkstra(_start_index)
    # set up variables
    count = vertices.length
    distances = Array.new(count, 1.0/0.0)
    distances[_start_index] = 0
    tight = []
    prev  = []
  
    count.times do
      # locate unvisited vertex with minimum distance, then mark it visited
      min = INF
      current = 0
      distances.each_with_index do |distance, i|
        if distance < min && !tight[i]
          min = distance
          current = i
        end
      end
      tight[current] = true
  
      # check whether path from chosen vertex to each of its neighbors 
      # results in a new minimum
      vertices[current][:neighbors].each do |n|
        n_ind = index_of(n[:neighbor])
        if (distances[current] + n[:weight].to_i < distances[n_ind])
          distances[n_ind] = distances[current] + n[:weight].to_i
          prev[n_ind] = current
        end
      end
    end
    return distances
  end

  #Алгоритм ФлойдаВаршала
  def floyd_warshall
    count = vertices.length
    distances = Array.new(count){Array.new(count, INF)}
    vertices.each_with_index do |vertex, index|
      distances[index][index] = 0
      vertex[:neighbors].each do |n|
        n_ind = index_of(n[:neighbor])
        distances[index][n_ind] = n[:weight].to_i
      end
    end
    cnt = count - 1
    for k in 0..cnt do
      for i in 0..cnt do
        for j in 0..cnt do
          if (distances[i][k] != INF && distances[k][j] != INF)
            minimum = [distances[i][j], distances[i][k] + distances[k][j]].min
            distances[i][j] = minimum
          end
        end
      end
    end
    return distances
  end

  #Алгоритм Белмана Форда
  def bellman_ford(_start_index)
    count = vertices.length
    isNegCycle = false
    distances = Array.new(count, INF)
    distances[_start_index] = 0
    i = 0
    while i < count - 1
      # Calculate shortest path distance from source to all edges
      # A path can contain maximum (|V|-1) edges
      vertices.each do |vertex|
        vertex[:neighbors].each do |n|
          u = index_of(vertex[:name])
          v = index_of(n[:neighbor])
          w = n[:weight].to_i
          if (distances[u] != INF && distances[u] + w < distances[v])
            distances[v] = distances[u] + w
          end
        end
      end
      i += 1
    end
    # Check the graph for negative cycle iterating over the edges once again
    vertices.each do |vertex|
      vertex[:neighbors].each do |n|
          u = index_of(vertex[:name])
          v = index_of(n[:neighbor])
          w = n[:weight].to_i
          if (distances[u] != INF && distances[u] + w < distances[v])
            isNegCycle = true
            break
          end
      end
    end
    return [isNegCycle, distances]
  end

  #хелпер метод ФордФулкерсон
  def ff_helper(_used, _current_index, _end_index, _max_flow)
    count = vertices.length
    return _max_flow if _current_index == _end_index
    _used[_current_index] = true
    vertices[_current_index][:neighbors].each do |n|
      n_ind = index_of(n[:neighbor])
      if (!_used[n_ind] && n[:weight].to_i > 0)
        min_flow = [_max_flow, n[:weight].to_i].min
        dist = ff_helper(_used, n_ind, _end_index, min_flow)
        if dist > 0
          n[:weight] = (n[:weight].to_i - dist).to_s
          vertices[n_ind][:neighbors].each do |nn|
            if nn[:neighbor] == _current_index
              nn[:weight] += dist
            end
          end
          return dist
        end
      end
    end
    return 0
  end

  #алгоритм ФордаФулкерсона
  def ford_fulkerson(_start_index, _end_index)
    flow = 0
    count = vertices.length
    while true
      used = Array.new(count, false)
      f = ff_helper(used, _start_index, _end_index, INF) # inf
      return flow if f == 0
      flow += f
    end
  end
  
#main
  def interface
    for i in (1..10000) do
      puts "<------Interface-------->"
      puts "<-Выберете одно из предложенных действий->"
      puts "1 - Добавить вершину, 2 - Удалить вершину"
      puts "3 - Добавить ребро, 4 - Удалить ребро, 5 - Вывести список смежности"
      puts "6 - Заполнить граф из файла, 7 - Вывести список смежности в файл, 8 - Выйти из интерфейса"
      puts "9 - a1n19, 10 - a1n20, 11 - b1n12, 12 - dva28, 13 - dva36 "
      print "Ваш выбор: "
      local = gets.to_i
      
      case local
      when 1
        print "Введите номер вершины: "
        num = gets.to_i
        add_vertex(num)
      when 2
        print "Введите номер вершины: "
        num = gets.to_i
        delete_vertex(num)
      when 3
        print "Введите номер вершины from: "
        v1 = gets
        print "Введите номер вершины to: "
        v2 = gets
        if ves == true
          print "Введите вес или оставьте поле пустым: "
          v3 = gets
          add_edge(v1, v2, v3)
        else
          add_edge(v1, v2)
        end
      when 4
        print "Введите номер вершины from: "
        v1 = gets.to_i
        print "Введите номер вершины to: "
        v2 = gets.to_i
        delete_edge(v1, v2)
      when 5
        vivod
      when 6
        #поменять путь на gets с консоли
        file_path = "GraphTest1.txt"
        if File.exist?(file_path)
          f = File.new(file_path, "r:UTF-8")
          lines = f.readlines
          f.close
          lines.each do |l|
            add_vertex(l.split(" ")[0])
          end
          lines.each do |l|
            l.split(" ").select.with_index do |letter, index|
              if index > 0
                add_edge(l[0], letter)
              end
            end
          end
        else
          puts "Файл не найден"
        end
      when 7
        #поменять путь на gets с консоли
        file_path = "GraphTest2.txt"
        if File.exist?(file_path)
          f = File.new(file_path, "w:UTF-8")
          
          vertices.each do |v|
            f.print("#{v[:name]} ")
            v[:neighbors].each do |n|
              f.print "#{n[:neighbor]} "
            end
              f.print("\n")
          end
          f.close
        else
          puts "Файл не найден"
        end
      when 8
        break
      when 9
        a1n19()
      when 10
        a1n20()
      when 11
        b1n12()
      when 12
        print "Введите номер вершины: "
        num = gets.to_i
        x,y = dva28(num)
        puts "Массив вершин #{y}"
        puts "Собсна массив путей для вершин #{x} "
      when 13
        print "Введите номер вершины: "
        num = gets.to_i
        x, y = dva28(num)
        puts "Экцентариситет вершины #{num} это #{x.max}"
        b = dva36()
        puts "радиус графа #{b.min}"
      when 14
        puts vertices
      when 15
        #test
        file_path = "GraphTest4.txt"
        if File.exist?(file_path)
          f = File.new(file_path, "r:UTF-8")
          lines = f.readlines
          f.close
          lines.each.with_index do |l, index|
            if index > 2
              add_vertex(l.split(" ")[0])
            end
          end
          lines.each do |l|
            l.scan(/\[(.*?)\]/).each do |letter|
              letter = letter.join("").tr('[', '').tr(']', '').tr(',', ' ')
              letter = letter.split(' ').to_a
              weight = nil
              if ves
                weight = letter[1]
                add_edge(l[0], letter[0], weight)
              else
                add_edge(l[0], letter[0])
              end
              #puts "from: #{l[0]} to #{letter[0]} weight #{letter[1]} \n"
            end
          end
        end
      when 16
        print kruskal
      when 17
        vertex_start = "1"
        vertex_end = "3"
        l = 1.0/0.0
        dk = dijkstra(index_of(vertex_start))
        exists_str = "не существует"
        dk_end = dk[index_of(vertex_end)]
        if (dk_end <= l && dk_end !=0)
          exists_str = "существует в этом графе с длиной #{dk_end}"
        end
        print "путь между Vertex #{vertex_start} и Vertex #{vertex_end} " + 
              exists_str + "\n"
      when 18
        vertex_name = "1"
        n = 1.0/0.0
        current_vertex = index_of(vertex_name)
        vertices_n = []
      
        fw = floyd_warshall
        print fw
        puts
        fw[current_vertex].each_with_index do |f, j|
          if (f <= n && f != 0)
            if !vertices_n.include? vertices[j][:name]
              vertices_n << vertices[j][:name]
            end
          end
        end

        print "вершины с дистанцией <= N это: #{vertices_n}" + "\n"
      when 19
        n = 5
        print "вершины с дистанцией >= N это: "
        flag = 0
          bellman_ford(1)[1].each.with_index do |v, i|
            if (v > n && v != 0)
              print  "#{i} "
              flag+=1
            end
          end
        if flag == 0
          print ' NULL'
        end
        puts
      when 20
        k = ford_fulkerson(index_of("0"), index_of("5"))
        puts "The maximum flow in this graph is: #{k}"
      else
        puts "incorrect number"
      end
    end
  end
end
#Минимальный консольный интерфейс
GraphArray = []
def showgraphs
  puts "<------Текущий список графов---------->"
  GraphArray.each.with_index do |g, index|
    puts "{ Index:#{index}, Name: #{g.name} }"
  end
end

for i in (1..10000) do
  puts "<------Interface-------->"
  puts "<-Выберете одно из предложенных действий->"
  puts "1 - Создать пустой граф, 2 - Склонировать граф с уже существующего"
  puts "3 - Создать граф из файла, 4 - Вывести все графы, 5 - Работать с существующим графом"

  chose = gets.to_i
  case chose
  when 1
    print "Введите имя графа: "
    name = gets.to_i
    print "Граф ориентированный? 1 - Yes, 0 - No: "
    ori = gets.to_i
    case ori
    when 0
      print "Граф взвешенный? 1 - Yes, 0 - No: "
      ves = gets.to_i
      if ves == 0
        g = Graph.new(name, false, false)
      else
        g = Graph.new(name, false, true)
      end
    when 1 
      print "Граф взвешенный? 1 - Yes, 0 - No: "
      ves = gets.to_i
      if ves == 0
        g = Graph.new(name, true, false)
      else
        g = Graph.new(name, true, true)
      end
    end
    GraphArray << g
    g.interface()
  when 2
    showgraphs()
    puts "Введите индекс графа который хотите склонировать"
    id = gets.to_i
    g_clone = GraphArray[id].clone
    print "Введите имя нового графа: "
    name = gets.to_s
    g_clone.change_name(name)
    GraphArray << g_clone
  when 3
    file_path = "GraphTest3.txt"
    if File.exist?(file_path)
      f = File.new(file_path, "r:UTF-8")
      lines = f.readlines
      f.close
      name = lines[0]
      orient = lines[1].to_i
      if lines[2].to_i == 1
        ves = true
      else 
        ves = false
      end
      g = Graph.new(name, orient, ves, file_path)
      GraphArray << g
    end
  when 4
    showgraphs()
  when 5
    showgraphs()
    puts "Введите индекс графа с которым хотите работать"
    id = gets.to_i
    GraphArray[id].interface
  end
end
