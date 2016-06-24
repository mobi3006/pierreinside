# JRebel
Deploying code changes (Java-Classes, JSF-Resources, Spring-Context-Changes, ...) to the server is done by:

    change resource in Eclipse
    mvn clean install
    copy artifacts to tomcat
    tomcat stops (automatically)
    tomcat starts (automatically)

This process takes - depending on the size of your application - some minutes ... several times a day.

In Java 1.5 the Hot-Swap mechanism was introduced but it is very restricted because it  allows only method body changes during remote debugging sessions. When I used it it was not very reliable (sometimes it worked ... most often: not).

Spring-Boot supports Warm-Restart and also Jetty supports some kind of Hot-Swapping (but still limited - I have heard of).

JRebel supports real Hot-Swapping of a wide range of refactorings

* http://zeroturnaround.com/software/jrebel/features/

It supports also a wide range of frameworks ... a lot of framework-specific refactorings (e. g. changing the spring context) are possible without restarting the application.

Have a look at the [white paper](http://files.zeroturnaround.com/pdf/JRebelWhitePaper2014.pdf) and the following video (https://vimeo.com/112443042):

  <a href="https://vimeo.com/112443042" target="_blank">
    <img 
      src="https://i.vimeocdn.com/video/543337819_130x73.jpg"
      alt="JRebel in 60 seconds" 
      width="240" height="130" border="73" />
  </a>

---

# Conservative Approaches
There are some approaches to reduce this costs:

* increase maven build and application server redeploy time
  * best idea - BUT: hard to reach
* use test-driven development
  * very good idea: BUT: for some modules (e. g. webui) in some situations too much overhead
* for JSF-UI-resources: configure Eclipse to work on JSF-resources directly
  * BENEFITS:
    * xhtml changes directly visible
  * DRAWBACKS
    * copy task back to the version controlled files needed (if you forget you loose code) works only for JSF resources .xhtml resources
* configure application server to use the Eclipse attached source folders (under version control) or the maven generated resource folders (containing .class, .xhtml, .properties).

---

# JRebel approach
JRebel transforms your IDE into a deployment tool ... the artifacts created by your IDE are integrated into the running deployment (inside or outside of your IDE):

![Typical Java Developer Environment](images/jrebel_typicalDevEnv.png)


