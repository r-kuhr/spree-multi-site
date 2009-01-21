# Spree Multi-Site Extension

The extension will allow you to setup multiple sites with one spree installation.  It gives you the ability to have different domains that direct to different stores with different layouts.  Orders, taxonomies and products will all be site specific entities now.

# Site Overview

To administer all of the sites go to `/admin/sites`.  There you can create a site instance.  Each site needs the following defined:

1. **Name:** Each site needs a name defined for it.  It is used purely for display purposes in the admin tool.  It _can_ be used in a _layout_ template as well.

2. **Domain:** Each site requires a domain to tell which site it should display.  So, if you want a site on _www.spreeshopping.com_ you would enter in that domain name here.  It will identify the site regardless of what port number you are coming in on (_3000_ which is the default for the development, _80_ for http, and _443_ for https).

3. **Layout _(optional)_:** If you want a different layout for your site, you enter in the layout name here.  Example: 'localhost' would look for the layout 'localhost.html.erb' in your `app/views/layout` directory.  In addition, if nothing is provided, it will use the default 'application' layout.

# Admin Changes
In addition to having a new section in the admin to manage sites and their domain, a few more things have been added to the following sections.

1. **Taxonomies:** In the Taxonomies section, you will now see that they are associated with `Sites`.  If you loaded the sample data you will see that they are associated with 'local'.  You can change what site a taxonomy is associated with by editing the taxonomy.  Click 'edit' on a taxonomy and you will have a drop-down now where you can associate which site the taxonomy is associated with.  Only taxonomies that are associated with a site will display for that site

2. **Products:** If you select a product from the admin to edit you will now notice in the 'Product Details' section that the site name for a product is selected from a dropdown ('local' by default).  Only products that are associated with a site will display in a site.

3. **Orders:** On the 'order listing' page, you will now see what site an order was placed on.  If you click into the details of the order you will also see what site the order was placed on in the 'Order Details' section.

# Installation

To install the extension run:
<pre>
script/extension install git://github.com/tunagami/spree-multi-site.git
</pre>

If you haven't already "bootstrapped" the spree database, when you run the bootstrap rake task, all of the the schemas and sample data will be created/updated.  If you just want to install the table schema and not use the sample data you can just run the rake task:
<pre>
rake db:migrate
</pre>
...otherwise if you want to have all of the sample data along with the sample data, you can run these rake tasks:
<pre>
rake db:migrate
rake spree:extensions:multi_site:bootstrap_multi_site
</pre>

# To Do's
+ Display site name with the taxons in the `product-edit-taxons` view