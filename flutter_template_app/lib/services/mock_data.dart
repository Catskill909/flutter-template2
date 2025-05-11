import '../models/dove_article.dart';

class MockData {
  static List<DoveArticle> getDoveArticles() {
    return [
      DoveArticle(
        title: 'Dove of Peace - Hancock',
        link: 'https://dovetrail.com/dove-of-peace-hancock/',
        description:
            'A beautiful dove sculpture in Hancock, NY. **Town:** Hancock **Artist:** Jane Smith',
        imageUrl:
            'https://images.unsplash.com/photo-1518674660708-0e2c0473e68e?q=80&w=1000',
        town: 'Hancock',
        artist: 'Jane Smith',
        pubDate: 'Mon, 10 Jan 2023 12:00:00 +0000',
        id: 1,
      ),
      DoveArticle(
        title: 'Harmony Dove - Delhi',
        link: 'https://dovetrail.com/harmony-dove-delhi/',
        description:
            'A stunning dove sculpture representing harmony. **Town:** Delhi **Artist:** John Davis',
        imageUrl:
            'https://images.unsplash.com/photo-1548767797-d8c844163c4c?q=80&w=1000',
        town: 'Delhi',
        artist: 'John Davis',
        pubDate: 'Tue, 15 Feb 2023 14:30:00 +0000',
        id: 2,
      ),
      DoveArticle(
        title: 'Freedom Dove - Walton',
        link: 'https://dovetrail.com/freedom-dove-walton/',
        description:
            'A symbol of freedom in Walton. **Town:** Walton **Artist:** Sarah Johnson',
        imageUrl:
            'https://images.unsplash.com/photo-1555169062-013468b47731?q=80&w=1000',
        town: 'Walton',
        artist: 'Sarah Johnson',
        pubDate: 'Wed, 22 Mar 2023 09:15:00 +0000',
        id: 3,
      ),
      DoveArticle(
        title: 'Unity Dove - Andes',
        link: 'https://dovetrail.com/unity-dove-andes/',
        description:
            'Representing unity in diversity. **Town:** Andes **Artist:** Michael Brown',
        imageUrl:
            'https://images.unsplash.com/photo-1621866908556-4f0a830707c9?q=80&w=1000',
        town: 'Andes',
        artist: 'Michael Brown',
        pubDate: 'Thu, 18 Apr 2023 16:45:00 +0000',
        id: 4,
      ),
      DoveArticle(
        title: 'Hope Dove - Margaretville',
        link: 'https://dovetrail.com/hope-dove-margaretville/',
        description:
            'A symbol of hope for the community. **Town:** Margaretville **Artist:** Emily Wilson',
        imageUrl:
            'https://images.unsplash.com/photo-1553531889-e6cf4d692b1b?q=80&w=1000',
        town: 'Margaretville',
        artist: 'Emily Wilson',
        pubDate: 'Fri, 26 May 2023 11:20:00 +0000',
        id: 5,
      ),
    ];
  }
}
