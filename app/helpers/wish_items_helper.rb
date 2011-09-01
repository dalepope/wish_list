module WishItemsHelper

  def make_wish(wish)
    wish_text = ""
    unless wish.category.none?
      wish_text = wish.category.name + ": "
    end
    wish_text += wish.description
    
    if wish.url.blank?
      wrap(wish_text)
    else
      link_to(wrap(wish_text), wish.url)
    end
  end

  def make_fake_wish
    fake_wish = 
      [ { :description => "Rubber bits", 
          :url => "http://www.amazon.com/Trojan-Durex-Condoms-Condom-Variety/dp/B000UXMN2A"
        },
        { :description => "Everything by John Milton",
          :url => "http://www.amazon.com/Complete-Poetry-Essential-Milton-Library/dp/0679642536"
        },
        { :description => "Beano tablets",
          :url => "http://www.amazon.com/Dietary-Supplement-Tablets-100-Count-Bottles/dp/B000FKJX2G"
        },
        { :description => "First season of Mama's Family",
          :url => "http://www.amazon.com/Mamas-Family-Complete-First-Season/dp/B000GH3PMM"
        },
        { :description => "World peace",
          :url => "http://zombo.com/"
        },
        { :description => "Everything by Tolstoy",
          :url => "http://www.amazon.com/Tolstoy-Karenina-Resurrection-Confession-ebook/dp/B000WT51FS"
        },
        { :description => "Socks",
          :url => "http://www.amazon.com/FULL-TILT-Cupcake-Pack-Socks/dp/B00594VC22"
        },
        { :description => "A Zune",
          :url => "http://www.amazon.com/Zune-Video-MP3-Player-Black/dp/B002JPITXY"
        },
        { :description => "Race car bed",
          :url => "http://www.amazon.com/Little-Tikes-Lightning-McQueen-Race/dp/B000FECQOY"
        },
        { :description => "Head wipes",
          :url => "http://www.baldguyz.com/headwipes"
        },
        { :description => "Pocket chair",
          :url => "https://www.pocketchair.com/"
        },
        { :description => "Tongue scraper",
          :url => "http://laughingsquid.com/his-and-her-tongue-scrapers/"
        },
        { :description => "A mogwai",
          :url => "http://www.youtube.com/watch?v=zoK0BzYUTrU"
        },
        { :description => "Red Ryder BB gun",
          :url => ""
        },
        { :description => "A cashmere sweater",
          :url => ""
        },
        { :description => "Okama Gamesphere",
          :url => ""
        },
        { :description => "An IBC towel",
          :url => ""
        },
        { :description => "USB Toaster",
          :url => "http://store.theonion.com/product/usb-powered-toastergift-box,29/"
        },
        { :description => "Potty putter",
          :url => "http://www.youtube.com/watch?v=Cp5FAbJvUEY"
        },
        { :description => "Spam",
          :url => "http://www.spam.com/"
        }
      ].sample
    
    if fake_wish[:url].blank?
      wrap(fake_wish[:description])
    else
      link_to(wrap(fake_wish[:description]), fake_wish[:url])
    end
  end
  
  def wrap(content)
    sanitize(raw(content.split.map{ |s| wrap_long_string(s) }.join(' ')))
  end

  private

    def wrap_long_string(text, max_width = 30)
      zero_width_space = "&#8203;"
      regex = /.{1,#{max_width}}/
      (text.length < max_width) ? text : 
                                  text.scan(regex).join(zero_width_space)
    end
end
