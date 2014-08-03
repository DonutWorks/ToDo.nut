$(function() {
  var colors = [
    {
      value: "#1f77b4",
      label: '#1f77b4'
    },{
      value: "#2ca02c",
      label: '#2ca02c'
    },{
      value: "#d62728",
      label: '#d62728'
    },{
      value: "#9467bd",
      label: '#9467bd'
    },{
      value: "#8c564b",
      label: '#8c564b'
    }
  ];

  

  $( "#combobox" ).autocomplete({
    minLength: 0,
    source: colors,
    focus: function( event, ui ) {
      $( "#combobox" ).val( ui.item.label );
      return false;
    },
    select: function( event, ui ) {
      $( "#combobox" ).val( ui.item.label );
      $( "#combobox-id" ).val( ui.item.value );
      $( "#combobox-description" ).html( ui.item.desc );
      $( "#combobox-icon" ).attr( "src", "images/" + ui.item.icon );

      return false;
    }
  })
  .autocomplete( "instance" )._renderItem = function( ul, item ) {
    return $( '<li style="background-color: ' + item.value + "\">" )
      .append( "<a>" + item.label + "</a>" )
      .appendTo( ul );
  };
});
