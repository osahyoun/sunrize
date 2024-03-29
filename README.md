Sunrize
=======

Simple Sinatra app which presents a [memrise](http://www.memrise.com) user with a JSON encoded representation of their account data (rank, points, total words learnt and so on). The app periodically visits memrise, keeping user data up-to-date.

## Getting Access
Visit [sunrize.me](http://www.sunrize.me) and submit your memrise username. Sunrize will then cache your usage statistics. If you're a well behaved boy or girl, sunrize will keep your data up-to-date (still pending).

Request your data with:

    http://www.sunrize.me/user/your-user-name

And you'll get something back like this:

    {
        "word_count": "315",
        "rank": "6329",
        "courses": [["French - The 1170 most common verbs", "http://www.memrise.com/set/10004259/french-the-1170-most-common-verbs/"], ["French GCSE", "http://www.memrise.com/set/589/french-gcse/"], ["Herbs", "http://www.memrise.com/set/10009208/herbs/"], ["Introductory French", "http://www.memrise.com/set/10007938/introductory-french/"], ["Introductory Spanish", "http://www.memrise.com/set/10007193/introductory-spanish/"]],
        "high_fives": "2",
        "points": "112726",
        "thumbs_up": "0",
        "courses_total": "5",
        "username": "osahyoun"
    }

JSONP is supported, just pass `callback` in your query string:

    http://www.sunrize.me/user/osahyoun?callback=blah

## Source

Sunrize's repo is available on GitHub, which can be browsed at:

    http://github.com/osahyoun/sunrize

and cloned with:

    git clone git://github.com/osahyoun/sunrize.git
