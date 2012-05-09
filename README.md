# Sunrize

Simple sinatra app which presents a [memrise](http://www.memrise.com) user with a JSON encoded representation of their account data (rank, points, words learnt and so on). The app periodically visits memrise, keeping user data up-to-date.

## Getting Access
Visit [sunrize.me](http://sunrize.me) and submit your memrise username. Sunrize will then cache your usage statistics. If you're a well behaved boy or girl, sunrize will keep your data up-to-date.

Request your data with:

    http://sunrize.me/user/:your-user-name

Your data looks like this:

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

