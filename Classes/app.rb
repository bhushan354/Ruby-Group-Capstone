require_relative 'book'
require_relative 'label'
require_relative 'author'
require 'json'
require 'date'
require_relative 'game'
require_relative 'author_service'
require_relative 'utils/util'
require_relative 'game_service'
require_relative 'music_album_service'

def list_menu_option_display
  puts 'Select choice'
  puts '  1. To list games'
  puts '  2. To Music Album (not yet available)'
  puts '  3. To list Music-Album (not yet available)'
  puts '  4. To list books'
  puts '  5. To list all items'
  puts '  0. Back to App menu'
  print 'List Items >> '
  gets.chomp.to_i
end

def create_item_options
  puts 'Select choice'
  puts '  1. To create game'
  puts '  2. To create book'
  puts '  3. To create Music Album (not yet available)'
  puts '  0. Back to App menu'
  print 'Add Items >> '
end

class App
  def initialize
    @books = []
    @labels = []
    @authors = []

    @all_things = []

    @items = []
    @music_album_creator = MusicAlbumService.new
    @author_manager = AuthorService.new
    @game_creator = GameService.new(@author_manager, @items)
  end

  def create_book
    date = get_date_input('Publishing date')

    first_name = get_non_empty_input('Publisher First Name')
    last_name = get_non_empty_input('Publisher Last Name')
    instance_author = Author.new(first_name, last_name)
    publisher = "#{first_name} #{last_name}"
    cover = get_non_empty_input('Cover state')

    book = Book.new(publisher, cover, date)
    @items << book
    @books << book
    instance_author.add_item(book)
    @authors << instance_author
    write_to_file(@authors, './dataJSON/authors.json')
    write_to_file(@books, './dataJSON/books.json')
    puts 'Book Created Successfully'
  end

  def list_books
    if @books.empty?
      puts "Book is empty\n\n"
    else
      puts "\nList of Books:"

      @books.each_with_index do |item, i|
        print "  #{i} | Publisher: #{item.publisher} - Cover_state: #{item.cover_state} "
        puts "- publish_date: #{item.publish_date} id: #{item.id}"
      end
      puts ''
    end
  end

  def create_label
    title = get_non_empty_input('Title')

    color = get_non_empty_input('Color')
    label = Label.new(title, color)
    @labels << label
    @items << label
    write_to_file(@labels, './dataJSON/labels.json')
    puts 'Label Created Successfully'
  end

  def display_labels
    @labels = read_from_file('./dataJSON/labels.json')
    puts 'Label list is empty' if @labels.empty?
    @labels.each_with_index do |label, i|
      puts "#{i}) Title: #{label.title}, Color: #{label.color}"
    end
  end

  def write_to_file(data, file_path)
    File.open(file_path, 'w') do |file|
      file.puts(JSON.generate(data))
    end
    puts "File written successfully to #{file_path}"
  rescue StandardError => e
    puts "Error writing to file #{file_path}: #{e.message}"
  end

  def read_from_file(file_path)
    JSON.parse(File.read(file_path))
  end

  def list_authors
    @author_manager.list_authors
  end

  def list_items
    if @items.empty?
      puts "Item is empty\n\n"
    else
      puts "\nList of Items:"

      @items.each_with_index do |item, i|
        author_first_name = item&.author ? " Author: \"#{item.author.first_name} #{item.author.last_name}\" " : nil
        puts "  #{i} | [#{item.class.name}] -#{author_first_name}Publish Date: #{item.publish_date}. id: #{item.id}"
      end
      puts ''
    end
  end

  def create_author
    @author_manager.create_author
  end

  def create_item
    loop do
      create_item_options

      choice = gets.chomp.to_i
      puts "\n"

      case choice
      when 1
        create_game
      when 2
        create_book
      when 3
        "Creating Music functionality is not yet implemented.\n\n"
      when 0
        break
      else
        puts 'Invalid choice. Please try again.'
      end
    end
  end

  def list_items_menu
    loop do
      choice = list_menu_option_display
      puts "\n"

      break if choice.zero?

      case choice
      when 1
        @game_creator.list
      when 2
        puts "Music listing functionality is not yet implemented.\n\n"
      when 3
        puts "Music-Album listing functionality is not yet implemented.\n\n"
      when 4
        list_books
      when 5
        list_items
      else
        puts 'Invalid choice. Please try again.'
      end
    end
  end

  def create_game
    @game_creator.create_game
  end

  def create_music_album
    @music_album_creator.create_music_album
  end

  def list_all_music_albums
    @music_album_creator.list_all_music_albums
  end

  # you can add your required def here
end
