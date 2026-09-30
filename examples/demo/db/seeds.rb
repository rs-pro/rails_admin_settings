Settings.set(:site_title, 'Settings Demo', label: 'Site title', overwrite: false)
Settings.set(:announcement, 'Edit this announcement in either admin.', kind: 'text', label: 'Announcement', overwrite: false)
Settings.ns('footer').set(:copyright, 'Made with RailsAdminSettings', label: 'Footer copyright', overwrite: false)
